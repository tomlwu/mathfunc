function V = ballVertices(r,o,n)
%BALLVERTICES generate n vertices of a approximated ball with radius r
%centered at o

if nargin<3
    n = 8;
end
[X_s,Y_s,Z_s] = sphere(n);%
V = r.*[[0,0,-1];[vec(X_s(2:end-1,1:end-1)),vec(Y_s(2:end-1,1:end-1)),vec(Z_s(2:end-1,1:end-1))];[0,0,1]]+o';
end

