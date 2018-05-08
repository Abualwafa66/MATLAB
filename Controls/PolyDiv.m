function [d,b]=PolyDiv(b,a)
% function [d,b]=PolyDiv(b,a)
% Perform polynomial division of a into b, resulting in d with remainder in the modified b.

m=length(b);
n=length(a);
if m<n; d = 0;
else
    if isa(b,'sym')|| isa(a,'sym'); syms d; end
    for j = 1:m-n+1;
        d(j) = b(1)/a(1);
        temp = PolyAdd(b(1:n),-d(j)*a);
        b(1:n) = [zeros(1,n-length(temp)), temp];
        b = b(2:end);
    end;
end
end % function PolyDiv
