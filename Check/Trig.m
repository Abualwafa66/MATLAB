clear all; close all; clc;
syms t x(t)
problem = '3*cos(5*t)+2*sin(5*t)';
answer = 'sqrt(13)*cos(5*t-0.588002603547568)';
x(t) = eval([problem, '-', answer]);
for t = 0:0.1:5;
    if eval(x(t)) >= 1e-8;
        disp('fail');
    end
end