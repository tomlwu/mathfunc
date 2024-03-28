function [u_sol,execution_time] = multSolveQP(method,H,f,A_ieq,b_ieq,A_eq,b_eq,lb,ub)
%MULTSOLVEQP Solve QP with muiltiple solvers
% the problem:
%       min 1/2*u'*H*u+f'*u
%       st. A_ieq*u<b_ieq
%           A_eq*u=b_eq


if nargin < 6
    A_eq = [];
    b_eq = [];
end
if nargin < 8
    lb = -100*ones(size(H,1),1);
    ub = 100*ones(size(H,1),1);
end

switch method
    case 'unconstrained'
        tic
        u = H\-f;%linsolve(H,-f);
        execution_time=toc;
    case 'quadprog'
        options = optimoptions('quadprog','Display','off');
        %                 options = optimoptions(@quadprog,'Algorithm','interior-point-convex','StepTolerance',0);
        tic
        u = quadprog(H,f,A_ieq,b_ieq,A_eq,b_eq,[],[],[],options);%quadprog(H,f,[],[],[],[],[],[],[],options);%
        execution_time=toc;
    case 'gurobi'
        model.Q = sparse(1/2*H);
        model.A = sparse([A_ieq;A_eq]);
        model.obj = f;
        model.rhs = [b_ieq;b_eq];
        model.lb = lb;
        model.ub = ub;
        model.sense = [repmat('<',size(A_ieq,1),1);repmat('=',size(A_eq,1),1)];
        params.outputflag = 1;
        params.OptimalityTol = 1e-7;
        params.FeasibilityTol = 1e-7;
        tic
        results = gurobi(model,params);
        execution_time=toc;
        u = results.x;
    case 'cvx'
        tic
        cvx_begin quiet
        variable u(size(H,1))
        minimize(1/2.*u'*H*u+f'*u)
        subject to
        A_ieq*u <= b_ieq;
        if ~isempty(A_eq)
            A_eq*u == b_eq;
        end
        cvx_end
        execution_time=toc;
end
u_sol = u;
end

