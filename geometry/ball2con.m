function [A,b] = ball2con(r,n)
%BALL2CON construct inequality Ax<b s.t. x is restrict in a ball centered
%at zero with radius r. [OPTIONAL]Set number of faces per latitude with n.
if nargin<2
    n = 20;
end
d = 3;
[X_s,Y_s,Z_s] = sphere(n);%
vertices = r.*[[0,0,-1];[vec(X_s(2:end-1,1:end-1)),vec(Y_s(2:end-1,1:end-1)),vec(Z_s(2:end-1,1:end-1))];[0,0,1]];
A = zeros(size(vertices,1),d);
b = r^2.*ones(size(vertices,1),1);
for iv = 1:size(vertices,1)
    A(iv,:) = vertices(iv,:)';
end
end

