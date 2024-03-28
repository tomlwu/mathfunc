function x = rtstack(Rs,Ts)
%RTSTACK stack reference frames separately in terms of rotations and
%translations
x = [vec(Ts); vec(matStackHor(Rs))];
end

