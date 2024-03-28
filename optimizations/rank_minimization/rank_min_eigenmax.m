function [M_out,solutionInfo] = rank_min_eigenmax(problem,method,M_initial)
%RANK_MIN_EIGENMAX minimizing the rank by maximizing the first singular value sigma1

n = problem.n;
objective_fun = problem.objective_fun;
A_eq = problem.A_eq;
b_eq = problem.b_eq;

%% settings
% mu = 0;
maxIter = 200;
tol_sigma = 1e-5;
tol_e = -1e-5;
tol_U = 1e-3;
flag_meas_mosek_time = false;

%% initialize
k = 1;
sigma_1 = zeros(n,1);
sigmas_all = zeros(7,n,maxIter);
grad_sigma_1 = zeros(49,n);
grad_sigma_1_M_vec = zeros(49*n,1);% stack(vec(grad_sigma_1*M_i)) for all i
M = M_initial;%+1e-7*repmat(eye(7),[1,1,n]);%filter out slight non-psd of the initial matrix
% M_vec = sdpik_rv2vec(M);
cost_obj = objective_fun(vec(M));
index_large_rank = true(n,1); % index of matrices whose rank is minimizable
for i_m = 1:n
    sigmas = sort(eig(M(:,:,i_m)),'descend');
    sigmas_all(:,i_m,1) = sigmas;
    sigma_1(i_m) = max(sigmas);
    grad_sigma_1(:,i_m) = grad_singularvalue(M(:,:,i_m),1,'psd');
    grad_sigma_1_M_vec(49*(i_m-1)+1:49*i_m,:) = grad_sigma_1(:,i_m);

    index_large_rank(i_m) = abs(sigma_1(i_m)-3)>=tol_sigma;
end

flag_solver_fail = false;
if flag_meas_mosek_time
    execution_time = 0;
end
U = 100*repmat(eye(7),[1,1,n]);
cvxtime = 0;

%% interation
while k<maxIter && (any(index_large_rank) && norm(U,"fro")>=tol_U)%|| cost_obj>=tol_cost

    cvx_begin sdp
    %     cvx_precision high
    if flag_meas_mosek_time
        cvx_solver_settings( 'dumpfile', 'cvx_dump' )
    end
    switch method
        case 'mosek'
            cvx_solver mosek_3
        case 'sdpt3'
            cvx_solver sdpt3
        case 'sedumi'
            cvx_solver sedumi
        otherwise
            error('Method name invalid!')
    end
    
%     n_doable = sum(index_doable);
    variable U(7,7,n) symmetric
%     expression U_vec(n*9,1)
%     U_vec = sdpik_rv2vec(U,U_vec);
    maximize(vec(U)'*grad_sigma_1_M_vec);%objective_fun(M_trans*vec(U+M))

    subject to

    A_eq*vec(U) == b_eq; % I,II, and III together

    % V) CBF condition
    for i_m = 1:n
        M(:,:,i_m)+U(:,:,i_m)>=0;
    end
    % VI) lower- and upper-bound U
%     vec(U)<=1*ones(49*n,1);
%     vec(U)>=-1*ones(49*n,1);

    cvx_end
    if flag_meas_mosek_time
        solver_res = load('cvx_dump.mat','res');
        execution_time_k = solver_res.res.info.MSK_DINF_OPTIMIZER_TIME;
        execution_time = execution_time + execution_time_k;
    end

    if strcmp(cvx_status,'Failed') || strcmp(cvx_status,'Infeasible') || strcmp(cvx_status,'Unbounded') || strcmp(cvx_status,'Overdetermined')
        flag_solver_fail = true;
        break
    end
    cost_obj = objective_fun(vec(U+M));%vec(U)'*grad_sigma_1_M_vec;
    disp(['k = ', num2str(k),', cost = ',num2str(cost_obj)]);
    disp(['sigma_1 = ',num2str(sigmas_all(1,:,k))]);
    M = M+U;
%     M_vec = sdpik_rv2vec(M);
    grad_sigma_1 = zeros(49,n);
    grad_sigma_1_M_vec = zeros(49*n,1);% stack(vec(grad_sigma_1*M_i)) for all i
    for i_m = 1:n
        sigmas = sort(eig(M(:,:,i_m)),'descend');
        sigmas_all(:,i_m,k+1) = sigmas;
        sigma_1(i_m) = max(sigmas);
        grad_sigma_1(:,i_m) = grad_singularvalue(M(:,:,i_m),1,'psd');
        grad_sigma_1_M_vec(49*(i_m-1)+1:49*i_m,:) = grad_sigma_1(:,i_m);

        index_large_rank(i_m) = abs(sigma_1(i_m)-3)>=tol_sigma;
    end
    cvxtime = cvxtime+cvx_cputime;
    k = k+1;
end
M_out = M;
disp('Rank minimization algorithm terminated with status:')
if flag_solver_fail
    disp('solver failed')
    exit_flag = 4;
else
    if k>=maxIter
        disp('max iteration reached!')
        exit_flag = 3;
    elseif ~any(index_large_rank)% &&  cost_obj<tol_cost
        disp('optimal solution with low rank!')
        exit_flag = 1;
    elseif norm(U,"fro")<tol_U
        disp('Stopped with small improvement!')
        exit_flag = 2;
    end
end
solutionInfo.execution_time = execution_time;
solutionInfo.singular_value_all = sigmas_all(:,:,1:k);
solutionInfo.eigenvalue_tolerance = tol_sigma;
solutionInfo.exitFlag = exit_flag;
solutionInfo.cvxtime = cvxtime;
end

