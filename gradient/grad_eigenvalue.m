function grad_eigen_k = grad_eigenvalue(M,k,varargin)
%GRAD_EIGENVALUE compute the gradient of the kth eigen value of M w.r.t. M.

flagsvd = false;
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'svd'
            flagsvd = true;
        otherwise
            disp(varargin{ivarargin})
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end

[m,~,p] = size(M);
grad_eigen_k = nan(m^2,p);

if flagsvd
    for i_p = 1:p
        [U,~,V] = svd(M(:,:,i_p));
        lambdas = sort(eig(M(:,:,i_p)),'descend');
        k_ip = k(i_p);
        if lambdas(k_ip)>0
            a_sign = 1;
        else
            a_sign = -1;
        end
        if k_ip <= 0
            J_sigma_k = zeros(m);
        else
            J_sigma_k = nan(m);
            for i = 1:m
                for j = 1:m
                    J_sigma_k(i,j) = a_sign*U(i,k_ip)*V(j,k_ip);
                end
            end
        end
        grad_eigen_k(:,i_p) = vec(J_sigma_k);
    end
else
    for i_p = 1:p
        [V,~] = eig(M(:,:,i_p));
        k_ip = k(i_p);

        if k_ip <= 0
            J_sigma_k = zeros(m);
        else
            J_sigma_k = nan(m);
            for i = 1:m
                for j = 1:m
                    J_sigma_k(i,j) = V(i,m-k_ip+1)*V(j,m-k_ip+1);
                end
            end
        end
        grad_eigen_k(:,i_p) = vec(J_sigma_k);
    end
end

end

