function [a,b] = halfspaceInequality(o,v,fp)
%HALFPLANEINEQUALITY generate an inequality ax<b of a half plane determined
%by a line passing through the point o with direction of vector v
% fp is a feasible point to determin sign
% d = numel(o);
% a = zeros(1,d);

if numel(v)==2
    a = [v(2),-v(1)];
else
    a = null(v');
    a = a(:,1)';
end
b = a*o;

% index = 1:d;
% for i = index
%     a(i) = sum(v(index~=i));
% end
% b = a*o;
if a*fp>=b
    b = -b;
end
end

