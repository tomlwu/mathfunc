function Rout = rot_stack(Rin)

if size(Rin,1)>size(Rin,2)
    flagVertical = true;
    d = size(Rin,2);
    nd = size(Rin,1);
else
    flagVertical = false;
    d = size(Rin,1);
    nd = size(Rin,2);
end
n = nd/d;
Rout = zeros(d,d);
for i = 1:n
    if flagVertical
        Rout(:,:,i)=blkij(Rin,[d,d],i,1);
    else
        Rout(:,:,i)=blkij(Rin,[d,d],1,i);
    end
end
end

function mat_out = blkij(A,D,i,j)
%BLKIJ gives the (i,j) block entry of a matrix
%   A := the matrix
%   D := the dimensions of the block
[m, n] = size(A);
d1 = D(1);
d2 = D(2);
if gcd(m,d1)~=d1 || gcd (n,d2)~=d2 || i*d1>m || j*d2>n
    error('Dimensional Error!')
end
mat_out = A(d1*(i-1)+1:d1*(i-1)+d1,d2*(j-1)+1:d2*(j-1)+d2);
end