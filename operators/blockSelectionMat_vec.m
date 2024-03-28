function M = blockSelectionMat_vec(n,m,pos)
%BLOCKSELECTIONMAT_VEC Given a matrix A of dimension (n,m), find the 
% linear matrix M that extraxts the [r1:r2,c1:c2] block of A such that 
% M*vec(A) = vec(A(r1:r2,c1:c2))
% pos = [r1, r2, c1, c2]

if numel(pos)~=4 && numel(pos)~=2
    error('block position should be 4 integers!')
end

if numel(pos)==2
    pos = kron(pos,[1,1]);
end

if any(pos(1:2)>n) || any(pos(3:4)>m)
    error('block position index exceed matrix dimension')
end

r1 = pos(1);
r2 = pos(2);
c1 = pos(3);
c2 = pos(4);

nr_blk = r2-r1+1;% number of rows of the block
nc_blk = c2-c1+1;% number of columns of the block

leftSelectionMat = zeros(nr_blk,n);
leftSelectionMat(:,r1:r2) = eye(nr_blk);

rightSelectionMat = zeros(m,nc_blk);
rightSelectionMat(c1:c2,:) = eye(nc_blk);

M = kron(rightSelectionMat',leftSelectionMat);

end

