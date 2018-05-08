clear all; close all; clc
nf = 80;
L = 10;

x  = 0:0.01:L;
RHS = x./L-sin((pi/(2*L)).*x);

LHS = zeros(1,length(x));
for i = 1:length(x);
    for n = 1:1:nf;
        B = -2*(-1)^n/((n*pi)*(1-4*n^2));
        LHS(i) = LHS(i) + B* sin(n*pi*x(i)/L);
    end
end
plot(x,RHS,x,LHS)
