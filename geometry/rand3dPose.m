function [T,R] = rand3dPose(n,goalSpace,orientSpace)
%RAND3DPOSE Generates n random 3D poses in the goalSpace, and orientSpace
% goalSpace: = [x1,x2;y1,y2;z1,z2]
% orientSpace: = [alpha1, alpha2; beta1, beta2; gamma1, gamma2];

T = rand3dpts(n,goalSpace);
angles = rand3dpts(n, orientSpace);
R = zeros(3,3,n);
for i = 1:n
    R(:,:,i) = rotz(angles(1,i))*roty(angles(2,i))*rotx(angles(3,i));
end
end

