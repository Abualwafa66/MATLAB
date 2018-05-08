function [z,p,k] = tf2zpk(num, den)

num = num(find(num,1):end);
den = den(find(den,1):end);

if length(num) > length(den);
    [p, z, k] = tf2zp(den, num);
    k = 1/k;
else [z, p, k] = tf2zp(num, den);
end

end