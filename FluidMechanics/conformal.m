clear all; close all; clc;
syms U Q G M real; syms a b c t real; syms x y X Y real; syms z z1 z2 Z;

%% Numerical Values (if wanted)
% Flow Field
a_num = 1; % location
b_num = 0;
c_num = 0;
t_num = 0;
x_lim = [0,5]; y_lim = [0,1]; % contour field size
contourlinenumber = 100; % contour line number
% Parallel Flow
p = [0 0];
U_num = 0;
% Source / Sink
s = [Q 1i*exp(pi/2); Q 1i*exp(-pi/2); Q -1i*exp(pi/2); Q -1i*exp(-pi/2); -2*Q 0];
Q_num = 1;
% Vortex
v = [0 0];
G_num = 0;
% Doublet
d = [0 0 0];
M_num = 0;

numerical = 1; 
%(0 for no numerical computaion, 1 for perform numerical computation)
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Complex Potential
fz = 0;
for kk = 1:size(p,1); fz = fz + p(kk,1)*exp( -p(kk,2)*1i)*z; end
for kk = 1:size(s,1); fz = fz + s(kk,1)*log(z-s(kk,2))/2/pi; end
for kk = 1:size(v,1); fz = fz - v(kk,1)*log(z-v(kk,2))/2/pi*1i; end
for kk = 1:size(d,1); fz = fz + d(kk,1)*exp(  d(kk,3)*1i)/(z-d(kk,2)); end

%% Schwartz-Christoffer transformation
z = exp(pi*Z/a);
%% Kutta-Jukowski transformation
% z1 = Z/2+sqrt((Z/2)^2-c^2);
% z2 = Z/2-sqrt((Z/2)^2-c^2);

%% Perform Transformation
FZ = fz;
FZ = eval(FZ);
WZ = diff(FZ,Z); Z = X+1i*Y;
W = eval(WZ); F = eval(FZ);
Vx = real(W); Vy = -imag(W);
PHI = real(F); XI = imag(F);
eval([ 'F_Vx = @(X,Y) ' char(Vx) ';']);
eval([ 'F_Vy = @(X,Y) ' char(Vy) ';']);

%% Numerical
if numerical
    U = U_num; Q = Q_num; G = G_num; M = M_num;
    a = a_num; b = b_num; t = t_num;
    eval([ 'F_XI = @(X,Y) ' char(XI) ';']);
    [x_grid, y_grid] = meshgrid(linspace(x_lim(1),x_lim(2),1000),linspace(y_lim(1),y_lim(2),1000));
    z_grid = F_XI(x_grid,y_grid);
    figure(1); set(1,'Position',[0 0 1920 1080]);
    %contour(x_grid, y_grid, z_grid, contourlinenumber); 
    contour(x_grid, y_grid, z_grid, [-1:0.02:1]);
    grid on; axis equal;
    title('Stream Lines');
    xlim(x_lim); ylim(y_lim);
end
