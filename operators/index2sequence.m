function s_vec = index2sequence(idx_vec)
%INDEX2SEQUENCE find sequence of true entries in an index vector

nb_index = numel(idx_vec);
s_vec = zeros(nb_index,1);

s = 1;
for i_s=1:nb_index
    if idx_vec(i_s)
        s_vec(i_s) = s;
        s = s+1;
    end
end

end

