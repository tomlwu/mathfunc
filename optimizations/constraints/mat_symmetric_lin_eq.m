function [A,b] = mat_symmetric_lin_eq(n)
%MAT_SYMMETRIC_LIN_EQ Generate the constraint Avec(M) = b for a [nxn]
%matrix M, such that M is symmetric.

nb_rows = (n^2-n)/2;
A = zeros(nb_rows,n^2);
b = zeros(nb_rows,1);
row = 1;
for i = 1:n
    for j = 1:n
        if i>j
            % {i,j}={j,i}
            index_vec_ij = matIndex2vecIndex(i,j,n,n);
            index_vec_ji = matIndex2vecIndex(j,i,n,n);
            A(row,:) = selectionMat(n^2,1,index_vec_ij(1),-index_vec_ji(1))';
            row = row + 1;
        end
    end
end
end

