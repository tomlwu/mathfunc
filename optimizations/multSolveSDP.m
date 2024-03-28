function [Y_sol,Y2,execution_time] = multSolveSDP(method,problem,varargin)
%MULTSOLVESDP Solves SDP with multiple optional solvers
% the problem: min trace(M*Y)
%              s.t. A1_eq1*Y*B1_eq1+A2_eq1*Y*B2_eq1=C_eq1
%                   A1_eq2*Y*B1_eq2+A2_eq2*Y*B2_eq2=C_eq2
%                     ...
%                   A1_eqn*Y*B1_eqn+A2_eqn*Y*B2_eqn=C_eqn
%                   A_ieq1*Y*B_ieq1<=C_ieq1
%                   A_ieq2*Y*B_ieq2<=C_ieq2
%                       ...
%                   A_ieqn*Y*B_ieqn<=C_ieqn


flagIdentityDiagonal = false;
flagAdditionalConstraints = false;
flagVarTrans = false;
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'diagonalindentity' % has dxd indentity matrices in block diagonal entries
            flagIdentityDiagonal = true;
            ivarargin=ivarargin+1;
            d=varargin{ivarargin};
        case 'additionalconstraints'
            flagAdditionalConstraints = true;
%             ivarargin=ivarargin+1;
%             addtlCons = varargin{ivarargin};
        case 'variabletransformation'
            flagVarTrans = true;
            ivarargin=ivarargin+1;
            vartransfun = varargin{ivarargin};
            dim_expression = problem.dim_expression;
            szY1_1 = dim_expression(1);
            szY1_2 = dim_expression(2);
        otherwise
            disp(varargin{ivarargin})
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end

dim = problem.dim;
M = problem.M;
A_eq = problem.A_eq;
B_eq = problem.B_eq;
C_eq = problem.C_eq;
A_ieq = problem.A_ieq;
B_ieq = problem.B_ieq;
C_ieq = problem.C_ieq;
objective_fun = problem.objective_fun;
if isfield(problem,'flagIdentityDiagonal')
    flagIdentityDiagonal = problem.flagIdentityDiagonal;
    d = problem.identityDiagonalBlockDim;
end

% extract parameters
szY2_1 = dim(1);
szY2_2 = dim(2);
A1_eq = A_eq.A1_eq;
A2_eq = A_eq.A2_eq;
B1_eq = B_eq.B1_eq;
B2_eq = B_eq.B2_eq;
fn_A1_eq = fieldnames(A1_eq);
fn_B1_eq = fieldnames(B1_eq);
fn_A2_eq = fieldnames(A2_eq);
fn_B2_eq = fieldnames(B2_eq);
fn_C_eq = fieldnames(C_eq);
num_eq_con = numel(fn_A1_eq);
if ~isempty(A_ieq)
    A1_ieq = A_ieq.A1_ieq;
    A2_ieq = A_ieq.A2_ieq;
    B1_ieq = B_ieq.B1_ieq;
    B2_ieq = B_ieq.B2_ieq;
    fn_A1_ieq = fieldnames(A1_ieq);
    fn_B1_ieq = fieldnames(B1_ieq);
    fn_A2_ieq = fieldnames(A2_ieq);
    fn_B2_ieq = fieldnames(B2_ieq);
    fn_C_ieq = fieldnames(C_ieq);
    num_ieq_con = numel(fn_A1_ieq);
end

tic
cvx_begin sdp
cvx_precision high
switch method
    case 'mosek'
        cvx_solver mosek
    case 'sdpt3'
        cvx_solver sdpt3
    case 'sedumi'
        cvx_solver sedumi
    otherwise
        error('Method name invalid!')
end
variable Y2(szY2_1,szY2_2) symmetric

if flagVarTrans %variable transformation
    expression Y1(szY1_1,szY1_2);
    Y1 = vartransfun(Y2,Y1);
else
    Y1 = Y2;
end
% minimize(norm_nuc(Y))
minimize(objective_fun(Y1))%trace(M*Y)
subject to
% trace(M*Y) == 6;
Y1>=0;
Y2>=0;
for i_eq = 1:num_eq_con
    if isempty(A2_eq.(fn_A2_eq{i_eq}))
        A1_eq.(fn_A1_eq{i_eq})*Y1*B1_eq.(fn_B1_eq{i_eq})==C_eq.(fn_C_eq{i_eq});
    else
        A1_eq.(fn_A1_eq{i_eq})*Y1*B1_eq.(fn_B1_eq{i_eq})...
            +A2_eq.(fn_A2_eq{i_eq})*Y1*B2_eq.(fn_B2_eq{i_eq})==C_eq.(fn_C_eq{i_eq});
    end
end

if flagIdentityDiagonal
    for i_blk = 1:szY1_1/d
        Ei = selectionMat(szY1_1/d,d,i_blk);
        Ei'*Y1*Ei == eye(d);
    end
end

if ~isempty(A_ieq)
    for i_ieq = 1:num_ieq_con
        if isempty(A2_ieq.(fn_A2_ieq{i_ieq}))
            A1_ieq.(fn_A1_ieq{i_ieq})*Y1*B1_ieq.(fn_B1_ieq{i_ieq})<=C_ieq.(fn_C_ieq{i_ieq});
        else
            A1_ieq.(fn_A1_ieq{i_ieq})*Y1*B1_ieq.(fn_B1_ieq{i_ieq})...
                +A2_ieq.(fn_A2_ieq{i_ieq})*Y1*B2_ieq.(fn_B2_ieq{i_ieq})...
                <=C_ieq.(fn_C_ieq{i_ieq});
        end
    end
end

if flagAdditionalConstraints
    %     addtlCons(Y2);
    n = (size(Y2,1)-1)/9;
    S1 = zeros(9,9);
    S2 = S1;
    S3 = S1;
    S1(1:3,4:6) = skew([1;0;0]);
    S2(1:3,4:6) = skew([0;1;0]);
    S3(1:3,4:6) = skew([0;0;1]);
    e7 = selectionMat(9,1,7);
    e8 = selectionMat(9,1,8);
    e9 = selectionMat(9,1,9);
    for i = 1:n
        trace(S1*Y2((i-1)*9+1:i*9,(i-1)*9+1:i*9))+e7'*Y2((i-1)*9+1:i*9,end)==0;
        trace(S2*Y2((i-1)*9+1:i*9,(i-1)*9+1:i*9))+e8'*Y2((i-1)*9+1:i*9,end)==0;
        trace(S3*Y2((i-1)*9+1:i*9,(i-1)*9+1:i*9))+e9'*Y2((i-1)*9+1:i*9,end)==0;
    end
end

cvx_end
execution_time=toc;
if flagVarTrans %variable transformation
    Y_sol = vartransfun(Y2);
else
    Y_sol = Y2;
end
end

