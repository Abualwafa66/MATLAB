clear all; close all; clc;
%% Input (Total Two)
%{
----- At LEAST one of the following ----
M1               (Upstream Mach Number)
M2               (Downstream Mach Number)
theta            (Change in Flow Direction)

----- At MOST one of the following ----
P = P2/P1        (Pressure Ratio)
rho = rho2/rho1  (Density Ratio)
U = U2/U1        (Velocity Ratio
T = T2/T1        (Temperature Raio)

1 denotes upstream of Prandtl-Meyer Expansion, 2 denotes downstrean of PME
%}
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Put your inputs here

M1 =  2.25;
P =  0.1;

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Equations
gamma = 1.4;
eq1 = 'x(3) - f_mu(x(2)) + f_mu(x(1));';
eq2 = 'x(4) - ((1+(gamma-1)/2*x(1)^2)/(1+(gamma-1)/2*x(2)^2))^(gamma/(gamma-1));';
eq3 = 'x(5) - x(4)^(1/gamma);';
eq4 = 'x(6) - x(2)/x(1)*sqrt(x(7));';
eq5 = 'x(7) - x(4)^((gamma-1)/gamma);';

%% PM Function
f_mu = @(M) sqrt((gamma+1)/(gamma-1))*atand(sqrt((gamma-1)/(gamma+1)*(M^2-1))) - atand(sqrt(M^2-1));

%% Check input
options=optimset('MaxIter',3000,'MaxFunEvals',3000,'TolFun', 1.0e-14, 'TolX',1.0e-14,'Display','off');
initial = [1;1;0;1;1;1;1];
check = 0;
if exist('M1','var'); s1 = sprintf('x(1) - %f ;',M1); initial(1) = M1; check = check + 1;
else s1 = []; end
if exist('M2','var'); s2 = sprintf('x(2) - %f ;',M2); initial(2) = M2; check = check + 1;
else s2 = []; end
if exist('theta','var'); s3 = sprintf('x(3) - %f ;',theta); initial(3) = theta; check = check + 1;
else s3 = []; end
if exist('P','var'); s4 = sprintf('x(4) - %f ;',P); initial(4) = P; check = check + 10;
else s4 = []; end
if exist('rho','var'); s5 = sprintf('x(5) - %f ;',rho); initial(5) = rho; check = check + 10;
else s5 = []; end
if exist('U','var'); s6 = sprintf('x(6) - %f ;',U); initial(6) = U; check = check + 10;
else s6 = []; end
if exist('T','var'); s7 = sprintf('x(7) - %f ;',T); initial(7) = T; check = check + 10;
else s7 = []; end
s = [s1 s2 s3 s4 s5 s6 s7];

if check == 2 || check == 11;
    eval([
        'f = @(x) [' s eq1 eq2 eq3 eq4 eq5 '];'
        ]);
    result = fsolve(f,initial,options);
    
    M1 = result(1); mu1 = f_mu(M1);
    M2 = result(2); mu2 = f_mu(M2);
    theta = result(3); P = result(4); rho = result(5); U = result(6); T = result(7);
    P1 = (1+(gamma-1)/2*M1^2)^(gamma/(gamma-1));
    P2 = (1+(gamma-1)/2*M2^2)^(gamma/(gamma-1));
    rho1 = (1+(gamma-1)/2*M1^2)^(1/(gamma-1));
    rho2 = (1+(gamma-1)/2*M2^2)^(1/(gamma-1));
    T1 = (1+(gamma-1)/2*M1^2); a1 = sqrt(T1);
    T2 = (1+(gamma-1)/2*M2^2); a2 = sqrt(T2);
    P0 = 1; T0 = 1; rho0 = 1; a0 = 1;
    %% Check Result
    check2 = zeros(1,3);
    if max(abs(f(result))) <= 1e-13; check2(1) = 1; end
    if M2 >= M1 && M1 >= 1; check2(2) = 1; end
    if theta >= 0 && theta <= 90; check2(3) = 1; end
    %% Display
    if all(check2)
        fprintf('===== Prandtl-Meyer Expansion =====\n');
        fprintf('theta = %3.4f deg\n', theta);
        fprintf('M1 = %3.4f, mu1 = %3.4f\n', M1,mu1);
        fprintf('M2 = %3.4f, mu2 = %3.4f\n', M2,mu2);
        fprintf('P2/P1 = %3.4f     (P)\n',P);
        fprintf('U2/U1 = %3.4f     (U)\n',U);
        fprintf('r2/r1 = %3.4f     (rho)\n',rho);
        fprintf('T2/T1 = %3.4f     (T)\n',T);
        fprintf('\nStagnation Properties \n       01/1        02/2        01/02 (PME is Isentropic)\n')
        fprintf('P   %8.4f    %8.4f    %8.4f (Always 1) \n',P1,P2,P0);
        fprintf('rho %8.4f    %8.4f    %8.4f (Always 1) \n',rho1,rho2,rho0);
        fprintf('T   %8.4f    %8.4f    %8.4f (Always 1) \n',T1,T2,T0);
        fprintf('a   %8.4f    %8.4f    %8.4f (Always 1) \n',a1,a2,a0);
    else fprintf('Solution Failed \n');
        if ~check2(1); disp('Solution did not converge, change initial guess');
        else
            if ~check2(2); fprintf('M1, M2 incorrect \nM1 = %3.4f, M2 = %3.4f \n',M1,M2);end
            if ~check2(3); fprintf('Theta not in range \ntheta = %3.4f deg \n',theta);end
        end
    end
else
    disp('Input error');
end


%%
% x(1) = M1
% x(2) = M2
% x(3) = theta
% x(4) = P
% x(5) = rho
% x(6) = U
% x(7) = T