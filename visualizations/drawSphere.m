function drawSphere(r,ctr,varargin)
%DRAWSPHERE draw a sphere

if nargin < 2 || isempty(ctr)
    ctr = [0;0;0];
end
color = 'm';
transparency = 0.3;


%optional parameters
ivarargin=1;
while(ivarargin<=length(varargin))
    switch(lower(varargin{ivarargin}))
        case 'color'
            ivarargin=ivarargin+1;
            color = varargin{ivarargin};
        case 'alpha'
            transparency = varargin{ivarargin};
        otherwise
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end

[X,Y,Z] = sphere(1024);
X = r*X+ctr(1);
Y = r*Y+ctr(2);
Z = r*Z+ctr(3);

h1 = surfl(X, Y, Z);
set(h1, 'FaceAlpha', transparency)
set(h1, 'FaceColor', color)
set(h1, 'EdgeColor', 'none')
end

