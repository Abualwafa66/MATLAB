clear all; close all; clc;
syms U Q G M real; syms a b t real; syms x y real; syms z;

%% Flow Field
a_num = 1; % location
b_num = 0;
t_num = 0;
x_lim = [-8,8]; y_lim = [-8,8]; % contour field size
contourlinenumber = 100; % contour line number
%% Parallel Flow
p = [U 0];
U_num = 1;
%% Source / Sink
s = [Q -a; -Q a];
Q_num = 4.3136*pi*U_num*a_num;
%% Vortex
v = [0 0];
G_num = 0;
%% Doublet
d = [0 0 0];
M_num = 0;

%% Stagnation point
stag = 1;
s_x = -sqrt(4.3136+1); s_y = 0;


numerical = 1; 
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Complex Potential
fz = 0;
for kk = 1:size(p,1); fz = fz + p(kk,1)*exp( -p(kk,2)*1i)*z; end
for kk = 1:size(s,1); fz = fz + s(kk,1)*log(z-s(kk,2))/2/pi; end
for kk = 1:size(v,1); fz = fz - v(kk,1)*log(z-v(kk,2))/2/pi*1i; end
for kk = 1:size(v,1); fz = fz - d(kk,1)*exp(  d(kk,3)*1i)/(z-d(kk,2)); end

wz = diff(fz,z); z = x+1i*y;
w = eval(wz); f = eval(fz);
u = real(w); v = -imag(w);
phi = real(f); xi = imag(f);
eval([ 'f_u = @(x,y)' char(u) ';']);
eval([ 'f_v = @(x,y)' char(v) ';']);
%% Numerical
if numerical
    U = U_num; Q = Q_num; G = G_num; M = M_num;
    a = a_num; b = b_num; t = t_num;
    eval([ 'f_xi = @(x,y)' char(xi) ';']);
    [x_grid, y_grid] = meshgrid(linspace(x_lim(1),x_lim(2),1000),linspace(y_lim(1),y_lim(2),1000));
    z_grid = f_xi(x_grid,y_grid);
    figure(1); set(1,'Position',[0 0 1920 1080]); hold on;
    contour(x_grid, y_grid, z_grid, contourlinenumber); grid on; axis equal;
    if stag
        contour(x_grid, y_grid, z_grid, [f_xi(s_x,s_y) f_xi(s_x,s_y)],'linewidth',2)
        disp('Stagnation Vx'); disp(eval(f_u(s_x,s_y)));
        disp('Stagnation Vy'); disp(eval(f_v(s_x,s_y)));
    end
    title('Stream Lines');
    xlim(x_lim); ylim(y_lim); grid on;
end