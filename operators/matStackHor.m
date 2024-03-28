%Stack a vector of matrices into a single vector
%function AVec=matStack(A)
%Take the slices of A in the third dimension and stacks them horizontaly.
%Input
%   A       Matrix of dimensions [d1 x d2 x d3]
%Output
%   AVec    Matrix of dimension [d1 x d2*d3]
function AVec=matStackHor(A)
d=size(A,2);
AVec=reshape(A,d,[]);


