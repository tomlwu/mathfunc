function t = rot_tightness(M)
%ROT_TIGHTNESS compute tightness of a matrix M by computing frobenius norm
%of M-rot_proj(M)

t = zeros(size(M,3),1);
for i = 1:size(M,3)
    t(i) = norm(M(:,:,i)-rot_proj(M(:,:,i)),"fro");
end
end

