function [num, den] = tfcoef(sys)

[num, den] = tfdata(sys,'v');
num = num(find(num,1):end);
den = den(find(den,1):end);

end