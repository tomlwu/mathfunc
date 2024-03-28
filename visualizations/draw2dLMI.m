function draw2dLMI(A,b,o)
%DRAW2DLMI visualize 2-D Linear inequality

if size(A,1)~=1 || size(A,2)~=2 || numel(b)~=1
    error("Dimension error! Can only do 2-D!")
end

k = -A(1)/A(2);
if nargin<3
    o = [-k,1;1/k,1]\[b/A(2);0];
end

barlength = 2;

d1 = barlength/2;
d2 = barlength/4;

pt1 = [o(1)-d1/sqrt(k^2+1);o(2)-k*d1/sqrt(k^2+1)];
pt2 = [o(1)+d1/sqrt(k^2+1);o(2)+k*d1/sqrt(k^2+1)];

if o(1)>0 && o(2)>0
    V = [-abs(k)*d2/sqrt(k^2+1);-d2/sqrt(k^2+1)];
elseif o(1)<0 && o(2)>0
    V = [abs(k)*d2/sqrt(k^2+1);-d2/sqrt(k^2+1)];
elseif o(1)<0 && o(2)<0
    V = [abs(k)*d2/sqrt(k^2+1);d2/sqrt(k^2+1)];
elseif o(1)>0 && o(2)<0
    V = [-abs(k)*d2/sqrt(k^2+1);d2/sqrt(k^2+1)];
else 
    V = [0;0];
end

plot([pt1(1),pt2(1)],[pt1(2),pt2(2)],'b')
hold on
quiver(o(1),o(2),V(1),V(2),'b')

end

