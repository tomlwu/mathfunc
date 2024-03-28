function drawDisk(o,axis,r)
%DRAWDISK Draws a 3-D disk given an origin o, radius r, and axis
%perpendicular to the center.
% r is optional and is 1 if omitted

angle_low = 0;
angle_high = 2*pi;
nb_angles = 20;
if nargin < 3
    r = 1; % radius scale
end
angles = linspace(angle_low,angle_high,nb_angles);
vect_sector = zeros(3,nb_angles);
vect0_on_disk = null(axis');
vect0_on_disk = vect0_on_disk(:,1);% a vector on the disk
for i_angle = 1:nb_angles
    vect_sector(:,i_angle) = o+r*rotaa(axis,angles(i_angle))*vect0_on_disk;
end
fill3([vect_sector(1,:)],...
    [vect_sector(2,:)],...
    [vect_sector(3,:)],'b','FaceAlpha',0.3)
end

