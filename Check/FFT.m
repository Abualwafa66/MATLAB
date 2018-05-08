clear all; close all; clc;

a0 = '160';
a = '400/(j*pi)*(sin(0.8*j*pi))';
b = '-400/(j*pi)*(cos(0.8*j*pi)-1)';
T = 0.15;
t0 = 0; tf = 0.15; dt = 0.001;
jmax = 1;


w0 = 2*pi/T;
y = zeros((tf-t0)/dt+1);
t = t0:dt:tf;
for i = 1:((tf-t0)/dt+1)
    y_cos = 0;
    y_sin = 0;
    for j = 1:jmax;
        y_cos = y_cos + eval([a '*cos(j*w0*t(i))']);
        y_sin = y_sin + eval([b '*sin(j*w0*t(i))']);
    end
    y(i) = eval(a0) + y_cos + y_sin;
end

plot(t,y)


