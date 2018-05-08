clear all; close all; clc; format long;
%
% Inputs
anser = 'sqrt(35)/5 * cos(sqrt(10)/2*t+0.564)';
% Solution
mck = [ 2 0 5 ];  
% mck of ODE
C = [ 1 -1 ];
% IC
%
%
%
syms q(t) t
q(t) = eval(anser);
Dq = diff(q);
D2q = diff(q,2);

IC1 = eval(q(0));
IC2 = eval(Dq(0));
if abs(C(1) - IC1) <= abs(0.01*C(1))
    disp('IC1 Check')
else fprintf('IC1 error %f %% \n',abs((C(1) - IC1)/C(1))*100);
end
if abs(C(2) - IC2) <= abs(0.01*C(2))
    disp('IC2 Check')
else fprintf('IC2 error %f %% \n',abs((C(2) - IC2)/C(2))*100);
end

i = 0;
ODE = eval(sprintf('%f *D2q + %f *Dq + %f *q',mck(1),mck(2),mck(3)));
if eval(ODE) == 0; disp('ODE Check');
else
    for t = 0:20;
        result = abs(eval(ODE(t)));
        if  result >= 0.01; disp(result);i = i+1; end
    end
end

if i == 0; disp('ODE Check'); end

t = linspace(0,10,1000);
x = zeros(1,1000);
for i = 1:1000;
    x(i) = q(t(i));
end
[max_x, index] = max(abs(x));
max_t = t(index);
fprintf('max amplitude: %f \nat time:       %f\n', max_x, max_t);

plot(t,x)