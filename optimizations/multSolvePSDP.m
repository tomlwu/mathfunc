function [Y,execution_time] = multSolvePSDP(method,problem)
%MULTSOLVEPSDP Solves SDP with multiple optional solvers
% the problem: min objective(Y)
%              s.t. A_eq*vec(Y)=b_eq
%                   M_i+Y_i>=0, for all i
% find Y: d x d x n, Y_i = Y(:,:,i) is symmetric

n = problem.n;
flag_M = false;
flag_eq = false;
objective_fun = problem.objective_fun;
if isfield(problem,'M')
    M = problem.M;
    flag_M = true;
end
if isfield(problem,'A_eq')
    flag_eq = true;
    A_eq = problem.A_eq;
    b_eq = problem.b_eq;
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
variable Y(7,7,n) symmetric
minimize(objective_fun(vec(Y)))%trace(M*Y)
subject to

if flag_eq
    if flag_M
        A_eq*vec(Y+M)==b_eq;
    else
        A_eq*vec(Y)==b_eq;
    end
end

if flag_M
    for i = 1:n
        Y(:,:,i)+M(:,:,i)>=0;
    end
else
    for i = 1:n
        Y(:,:,i)>=0;
    end
end

cvx_end
execution_time=toc;
end

