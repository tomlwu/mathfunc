function pts = rand3dpts(n,V)
%RAND3DPTS generates n random 3D points in space bounded by
% V: = [x1,x2;y1,y2;z1,z2]

pts = zeros(3,n);
for i = 1:n
    p_i = [(V(1,2)-V(1,1))*rand+V(1,1);...
        (V(2,2)-V(2,1))*rand+V(2,1);...
        (V(3,2)-V(3,1))*rand+V(3,1);];
    pts(:,i) = p_i;
end
end

