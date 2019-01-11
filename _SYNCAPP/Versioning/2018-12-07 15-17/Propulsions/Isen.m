clear all; close all; clc;
%% Input (one of the following)
%{
M                   (Mach Number)
G = G/rho0/a0/A     (Mass Flow rate)
rho0 = rho0/rho     (Desnsity Ratio)
P0 = P0/P           (Pressure Ratio)
T0 = T0/T           (Temperature Ratio)
a0 = a0/a           (Sound speed Ratio)
Where 0 denotes stagnation properties
%}
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Put your inputs here

M = 5;
%P0 = 150/101.325;
condition = 'sub'; % Outflow condition 'super' or 'sub' sonic

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Critical Properties (Sonic Conditions M = 1)
gamma = 1.4;
Pc = ((gamma+1)/2)^(gamma/(gamma-1));    % P0/Pc
rhoc = ((gamma+1)/2)^(1/(gamma-1));      % rho0/rhoc
Tc = (gamma+1)/2;                        % T0/Tc
ac = sqrt(Tc);                           % a0/ac

%% Equations
eq1 = 'x(2) - x(1)*(1+(gamma-1)/2*x(1)^2)^(-(gamma+1)/(2*gamma-2));';
eq2 = 'x(3)^(gamma-1) - 1 - (gamma-1)/2*x(1)^2;';
eq3 = 'x(4)^((gamma-1)/gamma) - 1 - (gamma-1)/2*x(1)^2;';
eq4 = 'x(5) - 1 - (gamma-1)/2*x(1)^2;';
eq5 = 'x(6)^2 - 1 - (gamma-1)/2*x(1)^2';

%% PM Function
f_mu = @(M) sqrt((gamma+1)/(gamma-1))*atand(sqrt((gamma-1)/(gamma+1)*(M^2-1))) - atand(sqrt(M^2-1));

%% Check input
options=optimset('MaxIter',3000,'MaxFunEvals',3000,'TolFun', 1.0e-14, 'TolX',1.0e-14,'Display','off');
if exist('Ac','var') && exist('condition','var');
    if strcmp(condition,'super');
        M_initial = 1;
    elseif strcmp(condition,'sub');
        M_initial = 0;
    end
    f1 = @(M) Ac - ((gamma+1)/2)^((gamma+1)/(2*gamma-2)) * M * (1+(gamma-1)/2*M^2)^(-(gamma+1)/2/(gamma-1));
    M = fsolve(f1,M_initial,options);
end

check = 0;
initial = [1;1;0;1;1;1];
if exist('M','var'); s1 = sprintf('x(1) - %f ;',M); initial(1) = M; check = check + 1;
else s1 = []; end
if exist('G','var'); s2 = sprintf('x(2) - %f ;',G); initial(2) = G; check = check + 1;
else s2 = []; end
if exist('rho0','var'); s3 = sprintf('x(3) - %f ;',rho0); initial(3) = rho0; check = check + 1;
else s3 = []; end
if exist('P0','var'); s4 = sprintf('x(4) - %f ;',P0); initial(4) = P0; check = check + 1;
else s4 = []; end
if exist('T0','var'); s5 = sprintf('x(5) - %f ;',T0); initial(5) = T0; check = check + 1;
else s5 = []; end
if exist('a0','var'); s6 = sprintf('x(6) - %f ;',a0); initial(6) = a0; check = check + 1;
else s6 = []; end
s = [s1 s2 s3 s4 s5 s6];

if check;
    eval([
        'f = @(x) [' s eq1 eq2 eq3 eq4 eq5 '];'
        ]);
    result = fsolve(f,initial,options);
    
    M = result(1); G = result(2);
    rho0 = result(3);P0 = result(4); T0 = result(5); a0 = result(6); u = M/sqrt(1+(gamma-1)/2*M^2);
    %% Critical Area
    Ac = ((gamma+1)/2)^((gamma+1)/(2*gamma-2)) * M * (1+(gamma-1)/2*M^2)^(-(gamma+1)/2/(gamma-1));
    %% Check Result
    check2 = zeros(1,1);
    if max(abs(f(result))) <= 1e-13; check2(1) = 1; end
    %% Display
    if all(check2)
        fprintf('===== Isentropic Flow =====\n');
        fprintf('Critical Properties (These are constants)\n');
        fprintf('P0/Pc = %3.4f     (Pc)\n',Pc);
        fprintf('a0/ac = %3.4f     (ac)\n',ac);
        fprintf('r0/rc = %3.4f     (rhoc)\n',rhoc);
        fprintf('T0/Tc = %3.4f     (Tc)\n\n',Tc);
        
        fprintf('M = %3.4f\n',M);
        if M >= 1; 
            mu = f_mu(M); 
            fprintf('mu = %3.4f [deg] (Prandtl-Meyer Function)\n',mu);
        end
        fprintf('u/ao = %3.4f   (u)\n',u);
        fprintf('\n');
        fprintf('P0/P = %3.4f    (P0)       Pc/P = %3.4f    (P0/Pc)\n',P0,P0/Pc);
        fprintf('a0/a = %3.4f    (a0)       ac/a = %3.4f    (a0/ac)\n',a0,a0/ac);
        fprintf('r0/r = %3.4f    (rho0)     rc/r = %3.4f    (rho0/rhoc)\n',rho0,rho0/rhoc);
        fprintf('T0/T = %3.4f    (T0)       Tc/T = %3.4f    (T0/Tc)\n\n',T0,T0/Tc);
        fprintf('Mass flow rate\n');
        fprintf('G/(r0*a0*A(x)) = %3.4f     (G)\n',G);
        fprintf('G/(r0*a0*Ac)   = %3.4f     (G/Ac)\n\n',G/Ac);
        fprintf('Critical Area (also best Nozzel Design)\n');
        fprintf('Ac/A(x) = %3.4f     (Ac)\n',Ac);
        fprintf('A(x)/Ac = %3.4f     (1/Ac)\n',1/Ac);
    else fprintf('Solution Failed \n');
        if ~check2(1); disp('Solution did not converge, change initial guess');end
    end
else
    disp('Input error');
end

%%
% x(1) = M
% x(2) = G = G/rho0/a0/A
% x(3) = rho0 = rho0/rho
% x(4) = P0 = P0/P
% x(5) = T0 = T0/T
% x(6) = a0 = a0/a
