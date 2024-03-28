function Ms = selectionMat(n,d,varargin)
%SELECTIONMAT build a selection matrix with i, j, k, ... block entries
%being 1 or -1 (negative if i<0)
% n is the total number of blocks
% d is the dimension
% enter block index starting from the third argument
% e.g., selectionMat(10,2,4,-9)
idx_pos = false(n,1);
idx_neg = false(n,1);
Ms = zeros(n,1);
if nargin > 2
    for i = 1:nargin-2
        index = double(varargin{i});
        if index > 0
            idx_pos(index)=true;
        end
        if index < 0
            idx_neg(abs(index))=true;
        end
    end
    Ms(idx_pos)=1;
    Ms(idx_neg)=-1;
    if d>1
        Ms = kron(Ms,eye(d));
    end
end
end

