function ball2con_sdp(v,r)
%BALL2CON_SDP construct sdp constraint [I,v;v',r]<=0 s.t. v is restrict in a ball centered
%at zero with radius r.

[eye(numel(v)),v;v',r]>=0;
end

