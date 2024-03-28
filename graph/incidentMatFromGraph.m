function M = incidentMatFromGraph(G)
%INCIDENTMATFROMGRAPH generate incident matrix of a graph given the graph
%(digraph) object G
% M is a [G.numedges x G.numnodes] matrix. Each row of M indicates a 
% connection btw. two nodes. In each row of M, the ith entry
% is -1 and the jth entry is 1. M is zero elsewhere.

M = zeros(G.numedges,G.numnodes);
[ep_1,ep_2] = find(G.adjacency==1);% edge pairs

for i_edge = 1:G.numedges
    M(i_edge,ep_1(i_edge,1)) = -1;
    M(i_edge,ep_2(i_edge,1)) = 1;
end

end

