clear all; close all; clc;
%% Known
M1 = 1.5939;
delta = 0;
condition = 'super';


%% ---------------------------------------------------------------
%% ---------------------------------------------------------------
%% Equations
gamma = 1.4;
f = @(b) tand(delta) - 2*cotd(b)*(M1^2*sind(b)^2-1)/(2+M1^2*(gamma+cosd(2*b)));

%% Check input
if strcmp(condition,'super');
    beta0 = 3;
elseif strcmp(condition,'sub');
    beta0 = 89.999;
end
options=optimset('MaxIter',12000,'MaxFunEvals',30000,'TolFun', 1.0e-13, 'TolX',1.0e-13);

beta = fsolve(f,beta0,options);

M1n = M1*sind(beta);
M2n = sqrt((2+(gamma-1)*M1n^2)/(2*gamma*M1n^2+1-gamma));
delta = atand(2*cotd(beta)*(M1^2*sind(beta)^2-1)/(2+M1^2*(gamma+cosd(2*beta))));
M2 = M2n/sind(beta-delta);



%% Calculate max delta
f2 = @(b) M1^4*sind(b)^2*(gamma+cosd(2*b)) - M1^2*(gamma+cosd(2*b)-2*sind(b)^2) -2 - 0.5*sind(2*b)^2*M1^4*(gamma+1);
beta_maxdelta = fsolve(f2,89.99,options);

delta_max = atand( 2*cotd(beta_maxdelta)*(M1^2*sind(beta_maxdelta)^2-1)/(2+M1^2*(gamma+cosd(2*beta_maxdelta))) );

%% Display
fprintf('Oblique Shock \n');
fprintf('Condition: %s sonic \n',condition);
fprintf('beta = %3.4f deg\n', beta);
fprintf('delta = %3.4f deg\n', delta);
fprintf('M1 = %3.4f, M1n = %3.4f \n', M1,M1n);
fprintf('M2 = %3.4f, M2n = %3.4f \n', M2,M2n);
fprintf('\nmax delta = %3.4f deg      (delta_max)\n',delta_max);

    %%
    % x(1) = M1
    % x(2) = M1n
    % x(3) = M2
    % x(4) = M2n
    % x(5) = beta
    % x(6) = delta
    % x(7) = P
    % x(8) = rho
    % x(9) = U
    % x(10) = T
    
    
    
