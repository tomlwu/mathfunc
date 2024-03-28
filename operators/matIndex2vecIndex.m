function ind_vec = matIndex2vecIndex(i,j,m,n)
%MATINDEX2VECINDEX convert a matrix index to vector index

seq_vec_full = reshape((1:m*n)',m,n);
ind_vec = [seq_vec_full(i,j),1];
end

