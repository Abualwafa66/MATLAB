function [x,y,r,s] = Diophantine(a,b,c)
% function [x,y,r,s] = Diophantine(a,b,c)
% Solve the polynomial Diophantine eqn a*x+b*y=c via the Extended Euclidean algorithm
% for coprime {a,b}.  The solution {x,y} returned is the solution with the lowest order
% for y; the general solution is given by {x+r*t,y+s*t} for any polynomial t.

a = a(find(a,1):end);
b = b(find(b,1):end);

n=max(2,abs(length(a)-length(b))+1);
rm=a; r=b;
for i=1:n+2
    r=r(find(r,1):end);
    [quo,rem]=PolyDiv(rm,r);  % Reduce (rm,r) to their GCD via Euclid's
    q(i,n+3-length(quo):n+2)=quo;
    rm=r; r=rem;
    if norm(r,inf)<1e-13; g=rm; break; end;
end
r=-PolyDiv(b,g);
s=PolyDiv(a,g);
y=PolyDiv(c,g);
x=0;
for j=i-1:-1:1                            % Using q as computed above, compute {x,y}
    t=x; x=y;
    y=PolyAdd(t,-PolyConv(q(j,:),y));   % via the Extended Euclidean algorithm
end
y=y(find(y,1):end);
[div,~]=PolyDiv(y,s); t=-div;   % Find the solution {x,y} that
x=PolyAdd(x,PolyConv(r,t));
x=x(find(abs(x)>1e-8,1):end); % minimizes the order of y; this
y=PolyAdd(y,PolyConv(s,t));
y=y(find(abs(y)>1e-8,1):end); % is the most useful in practice

y = real(y);
x = real(x);

y = y./x(1);
x = x./x(1);

end % function Diophantine