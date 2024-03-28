function [A,f,C] = ellipsoidInequality(a,b,c,R,T)
%ELLIPSOIDINEQUALITY generates a quadratic inequality constraint 
% x'Ax+f'x+C<=0
% INPUT ARGUMENTS: a,b,c are the ellipsoid half widths along x-, y-, and z-
% axes; [OPTIONAL] R, T are the orientation and location of the center

if nargin < 4
    R = eye(3);
    T = zeros(3,1);
end

A_unrot = diag([1/a^2,1/b^2,1/c^2]);
R = R';

A = R'*A_unrot*R;
f = (-2*T'*R'*A_unrot*R)';
C = T'*R'*A_unrot*R*T-1;

end

