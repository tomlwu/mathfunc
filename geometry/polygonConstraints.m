function [A_ieq,b_ieq,A_eq,b_eq] = polygonConstraints(V)
%PLOYGONINEQUALITIES generate inequalities Ax<=b and Equalities Cx=d of 
%a polygon given by vertices V [d x nbV]
% Assume polygon is convex

[d,nbV] = size(V);
A_ieq = zeros(nbV,d);
b_ieq = zeros(nbV,1);
cp = mean(V,2); %center point
if nargout >= 3
    ov = cross(V(:,1)-V(:,2),V(:,2)-V(:,3)); % orthogonal vector
end
for iV = 1:nbV
    o_i = V(:,iV);
    if iV == nbV
        v_i = V(:,1)-V(:,iV);
    else
        v_i = V(:,iV+1)-V(:,iV);
    end
    I = v_i~=0;
    [ai,bi] = halfspaceInequality(o_i(I),v_i(I),cp(I));
    a_aug = zeros(size(v_i));
    a_aug(I) = ai;
    ai=a_aug;
    A_ieq(iV,:) = ai;
    b_ieq(iV) = bi;
    if nargout >= 3
        A_eq = ov';
        b_eq = 0;%ov'*V(:,1);
    end
end
end

