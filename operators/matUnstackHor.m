%Transform a stack of matrices into a 3-D array
%function A=matUnstack(AVec,dUnstack)
%Given a vector where each block AVec(:,d*(i-1)+1:d*i) is a matrix, return
%the [d x d x N] array of matrices containing the various blocks.
%If omitted, dUnstack=d.
function A=matUnstackHor(AVec)
d=size(AVec,1);
A=reshape(AVec,d,d,[]);
