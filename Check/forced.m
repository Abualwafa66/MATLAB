clear all; close all; clc; format long;
%
%
%
% Inputs
syms w
a = 1-w^2/5;
b = 2*w/5;
delta = 3/5;
%
mck = [ 1 2 5 ];
F0 = 3;
FF = 'cos';
% mck of ODE
%
%
%
%
phi = atan2(b,a);
anser = 'delta*(1/sqrt(a^2+b^2)) * cos(w*t-phi)';
% Solution

%
%
%
syms q(t) t
q(t) = eval(anser);
Dq = diff(q);
D2q = diff(q,2);

F = sprintf('%f * %s (w*t)',F0,FF);
ODE = eval(sprintf('%f *D2q + %f *Dq + %f *q - %s',mck(1),mck(2),mck(3),F));
i = 0;
for w = 0:20;
    if isfloat(eval(ODE))
        if abs(eval(ODE)) >= 1e-13;
            fprintf('ODE = %d, error\n', eval(ODE)); i = i+1;
        end
    else for t = 0:20;
            result = abs(eval(ODE(t)));
            if  result >= 1e-10
                fpritntf('ans = %f, error',result); i = i+1;
            end
        end
    end
end

if i == 0;
    disp('ODE Check');
end