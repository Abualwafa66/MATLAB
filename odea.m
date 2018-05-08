function [x, T] = odea(f,range,IC,~)

xi = range(1); xf = range(2);
[m,n] = size(IC);
if m == 1; IC = IC'; m = n; end;
n = ceil((xf-xi)*3e6);
T = zeros(m,n); x = zeros(1,n);
T(:,1) = IC; x(1) = xi;
for i = 1:1:n-1
    dx = min(1e-6/max(abs(f(x(i),T(:,i)))),1e-5);
    k1 = dx.*f( x(i)     , T(:,i)      );
    k2 = dx.*f( x(i)+dx/2, T(:,i)+k1/2 );
    k3 = dx.*f( x(i)+dx/2, T(:,i)+k2/2 );
    k4 = dx.*f( x(i)+dx  , T(:,i)+k3   );
    T(:,i+1) = T(:,i) + 1/6.*(k1+2*k2+2*k3+k4);
    x(i+1) = x(i) + dx;
    if x(i+1) >= xf; break; end;
end

T(:,i+2:end) = [];
x(:,i+2:end) = [];
T = T';
x = x';

end