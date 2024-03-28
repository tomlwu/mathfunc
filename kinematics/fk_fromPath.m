function A = fk_fromPath(P,G,Te)
%FK_FROMPATH Generate parameter A forward kinematic function 
% A*vec(R)+T_base = T
% given a path P, a graph G, and its base location T_base. T is the 
% position of the end frame of the path. 
% Te is the local translations of each intermidiate frame

A = zeros(3,n*9);%kron(selectionMat(n,1,P)',kron([0;0;0]',eye(3)));
[ep_1,ep_2] = find(G.adjacency==1);
for r = 1:lenth(P)-1
    i = P(r);
    j = P(r+1);
    i_edge = find(sum(abs([ep_1,ep_2]-[i,j]),2)==0,1);% find the edge index
    A(:,(i-1)*9+1:i*9)=kron(Te(:,i_edge)',eye(3));
end
end
