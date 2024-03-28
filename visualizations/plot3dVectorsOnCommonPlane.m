function P = plot3dVectorsOnCommonPlane(v1,v2,v_extras,varargin)
%PLOT3DVECTORSONCOMMONPLANE Plot 2 3D vectors on their common plane as a
%2-D figure
%output the projection matrix P
% plot aditional vectors input as columns in v_extras

flagDefualtColor = true;
if nargin<3
    flagPlotAddtl = false;
else
    flagPlotAddtl = true;
end

ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case    'color'            % output the process
            flagDefualtColor = false;
            ivarargin=ivarargin+1;
            style = lower(varargin{ivarargin});
        otherwise
            disp(varargin{ivarargin})
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end

if flagDefualtColor
    style = {'r','b'};
end

P = orth([v1 v2]);
r1 = P'*v1;
r2 = P'*v2;
quiver(0,0,r1(1),r1(2),'Color',style{1})
hold on;
quiver(0,0,r2(1),r2(2),'Color',style{2})

if flagPlotAddtl
    nb_vs = size(v_extras,2);
    for i = 1:nb_vs
        ri = P'*v_extras(:,i);
        if flagDefualtColor
            quiver(0,0,ri(1),ri(2))
        else
            quiver(0,0,ri(1),ri(2),'Color',style{2+i})
        end
    end
end
end

