function [H_out,f_out,C] = separateLinearTerms(H,idx_0,x0)
%SEPARATELINEARTERMS Given a Matrix H and the function g(x) = x'Hx, suppose
%there is known real entries x0 = x(idx_0) and unknown entries 
% x1 = x(~idx_0), this program outputs H_out, f_out and C such that
% x1'H_outx1+f_out'x_1+C = x'Hx
H_out = H(~idx_0,~idx_0);
f_out = (x0'*H(idx_0,~idx_0)+x0'*(H(~idx_0,idx_0))')';
C = x0'*H(idx_0,idx_0)*x0;
end

