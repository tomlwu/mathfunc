function M = matkron3D(A,B)
%MATKRON3D multiply 3D matrices A and B such that M(:,:,i) =
%kron(A(:,:,i),B*(:,:,i))
n = size(A,3);
M = nan(size(A,1)*size(B,1),size(A,2)*size(B,2),n);
for i = 1:n
    M(:,:,i) = kron(A(:,:,i),B(:,:,i));
end
end

