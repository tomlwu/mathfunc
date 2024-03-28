%Transform a stack of matrices into a 3-D array
%function A=matUnstackND(AVec,dUnstack)
%Given a vector where each block AVec(dUnstack*(i-1)+1:dUnstack*i,:) is a matrix, return
%the [dUnstack x d x N] array of matrices containing the various blocks.
function A = matUnstackND(AVec,dUnstack)
d = size(AVec,2);
N = size(AVec,1)/dUnstack;
A = zeros(dUnstack,d,N);
for i = 1:N
    A(:,:,i) = AVec(dUnstack*(i-1)+1:dUnstack*i,:);
end
end

