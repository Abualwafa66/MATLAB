clear all; close all; clc;
x = [0:0.0001:10];
y = tan(x)-1./x;
plot(x, tan(x),'r',x,1./x,'g')
axis([0 10 -5 5]);

for i = 1:length(x)-1;
    if y(i)*y(i+1) <=0;
        disp(x(i));
    end
end
