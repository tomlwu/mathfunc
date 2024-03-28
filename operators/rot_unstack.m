function Rout = rot_unstack(R,varargin)
assert(size(R,1)==size(R,2))
flagVertical = false;
ivarargin=1;
while ivarargin<=length(varargin)
    switch lower(varargin{ivarargin})
        case 'vertical'
            ivarargin=ivarargin+1;
            flagVertical = true;
        case 'horizontal'
            ivarargin=ivarargin+1;
            flagVertical = false;
        otherwise
            disp(varargin{ivarargin})
            error('Argument not valid!')
    end
    ivarargin=ivarargin+1;
end
d = size(R,1);
n = size(R,3);
Rout = zeros(d,n*d);
for i = 1:n
    if flagVertical
        Rout((i-1)*d+1:(i-1)*d+d,:)=R(:,:,i);
    else
        Rout(:,(i-1)*d+1:(i-1)*d+d)=R(:,:,i);
    end
end
end