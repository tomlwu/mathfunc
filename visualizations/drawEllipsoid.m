function drawEllipsoid(a,b,c,R,T,varargin)
%DRAWELLIPSOID plots an ellipsoid
% INPUT ARGUMENTS: a,b,c are the ellipsoid half widths along x-, y-, and z-
% axes; [OPTIONAL] R, T are the orientation and location of the center

flagAlpha = false;
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'alpha'
            flagAlpha = true;
            ivarargin = ivarargin+1;
            alphaVal = varargin{ivarargin};
        otherwise
            disp(varargin{ivarargin})
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end

if nargin < 4
    R = eye(3);
    T = zeros(3,1);
end

% [A,f,C] = ellipsoidInequality(a,b,c,R,T);

[X,Y,Z] = ellipsoid(0,0,0,a,b,c);
s = surf(X,Y,Z);
angles_euler = rad2deg(rot2euler(R));
rotate(s,[1,0,0],angles_euler(1))
rotate(s,[0,1,0],angles_euler(2))
rotate(s,[0,0,1],angles_euler(3))

if flagAlpha
    alpha(alphaVal)
end
end

