function M = sparseMatfromBlocks(idx1,idx2,blks,sz1,sz2)
%SPARSEMATFROMBLOCKS Construct a [sz1 x sz2] (blockwise) sparse matrix from blocks
% "blks(d1 x d2 x nb_blks)" indicated by block indeces idx1, idx2.

if numel(idx1)~=numel(idx2)
    error('Indeces must have same size!');
end
nb_blks = size(blks,3); % number of blocks
if numel(idx1)~=nb_blks
    error('Number of indices must match number of blocks!');
end
if max(idx1)>sz1 || max(idx2)>sz2
    error('Index exceed number of blocks!')
end
d1 = size(blks,1);
d2 = size(blks,2);

idx_expand_1 = kron((idx1-1)*d1,ones(d1,1))+repmat((1:d1)',nb_blks,1);
idx_expand_2 = kron((idx2-1)*d2,ones(d2,1))+repmat((1:d2)',nb_blks,1);

M = builtin('sparse',vec(matUnstack(repmat(idx_expand_1,1,d2),d1)),...
    kron(idx_expand_2,ones(d1,1)),...
    double(vec(blks)));

% complete matrix
M = blkdiag(M,sparse((sz1-max(idx1))*d1,(sz2-max(idx2))*d2));
 
end

