function M = matShift(A,d)
%MATSHIFT reverse the sequence of a matrix in the direction specified by d
M = zeros(size(A));
switch d
    case 1
        for i = 1:size(A,1)
            M(end-i+1,:) = A(i,:);
        end
    case 2
        for i = 1:size(A,2)
            M(:,end-i+1) = A(:,i);
        end
    case 3
        for i = 1:size(A,3)
            M(:,:,end-i+1) = A(:,:,i);
        end
    otherwise error('Can only do 1st to 3rd dimensions!');
end
end