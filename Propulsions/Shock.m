clear all; close all; clc;
%% Input (Total Two)
%{ 
----- At LEAST one of the following ----
M1            (Upstream Mach Number for stationary shock)
M2            (Downstram Mach Number for stationary shock)
M2n           (Normal Component of downstream Mach Number)
beta          (angle between u1 and shock) (beta = 90 for normal shock)
delta         (change in angle of u1 and u2) (delta = 0 for normal shock)

----- At MOST one of the following ----
M1n                  (Normal Component of upstream Mach Number)
P = P2/P1            (Pressure ratio)
rho = rho2/rho1      (Density ratio)
U = U2/U1            (Velocity ratio)
T = T2/T1            (Temperature ratio)
dUn = (U2n-U1n)/a1   (Difference in normal component of velocity)
                     (independent of reference frame)

1 denotes Upstream of Shock; 2 denotes Downstream of Shock
%} 
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Put your inputs here

dUn = -0.9623;
% M1 = 2;
beta = 90;
condition = 'sub'; % Outflow condition 'super' or 'sub' sonic

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Equations
gamma = 1.4;
eq1 = 'x(4) - sqrt( (2+(gamma-1)*x(2)^2)/(2*gamma*x(2)^2+1-gamma) );';
eq2 = 'x(2) - x(1)*sind(x(5));';
eq3 = 'x(4) - x(3)*sind(x(5)-x(6));';
eq4 = 'tand(x(6)) - 2*cotd(x(5))*( x(2)^2-1 )/( 2+x(1)^2*(gamma+cosd(2*x(5))) );';
eq5 = 'x(7) - (2*gamma*x(2)^2+1-gamma)/(1+gamma);';
eq6 = 'x(8) - 1/x(9);';
eq7 = 'x(9) - (2+(gamma-1)*x(2)^2)/((gamma+1)*x(2)^2);';
eq8 = 'x(10) - x(7)/x(8);';
eq9 = 'x(11) + (2/(gamma+1))*(x(2)^2-1)/x(2)';

%% Check input
if strcmp(condition,'super');
    beta0 = 40;
elseif strcmp(condition,'sub');
    beta0 = 89.999;
end
initial = [1;1;1;0;beta0;0;1;1;1;1;1];
options=optimset('MaxIter',3000,'MaxFunEvals',3000,'TolFun', 1.0e-14, 'TolX',1.0e-14,'Display','off');
check = 0;
if exist('M1','var'); s1 = sprintf('x(1) - %f ;',M1); initial(1) = M1; check = check + 1;
else s1 = []; end
if exist('M1n','var'); s2 = sprintf('x(2) - %f ;',M1n); initial(2) = M1n; check = check + 10;
else s2 = []; end
if exist('M2','var'); s3 = sprintf('x(3) - %f ;',M2); initial(3) = M2; check = check + 1;
else s3 = []; end
if exist('M2n','var'); s4 = sprintf('x(4) - %f ;',M2n); initial(4) = M2n; check = check + 1;
else s4 = []; end
if exist('beta','var'); s5 = sprintf('x(5) - %f ;',beta); initial(5) = beta; check = check + 1;
else s5 = []; end
if exist('delta','var'); s6 = sprintf('x(6) - %f ;',delta); initial(6) = delta; check = check + 1;
else s6 = []; end
if exist('P','var'); s7 = sprintf('x(7) - %f ;',P); initial(7) = P; check = check + 10;
else s7 = []; end
if exist('rho','var'); s8 = sprintf('x(8) - %f ;',rho); initial(8) = rho; check = check + 10;
else s8 = []; end
if exist('U','var'); s9 = sprintf('x(9) - %f ;',U); initial(9) = U; check = check + 10;
else s9 = []; end
if exist('T','var'); s10 = sprintf('x(10) - %f ;',T); initial(10) = T; check = check + 10;
else s10 = []; end
if exist('dUn','var'); s11 = sprintf('x(11) - %f ;',dUn); initial(11) = dUn; check = check + 10;
else s11 = []; end
s = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11];

if check == 2 || check == 11;
    %% Solve
    eval([
        'f = @(x) [' s eq1 eq2 eq3 eq4 eq5 eq6 eq7 eq8 eq9 '];'
        ]);
    
    result = fsolve(f,initial,options);
    
    M1 = result(1); M1n = result(2);
    M2 = result(3); M2n = result(4);
    beta = result(5); delta = result(6);
    P = result(7); rho = result(8); U = result(9);
    T = result(10); dUn = result(11);
    P1 = (1+(gamma-1)/2*M1^2)^(gamma/(gamma-1));
    P2 = (1+(gamma-1)/2*M2^2)^(gamma/(gamma-1));
    rho1 = (1+(gamma-1)/2*M1^2)^(1/(gamma-1));
    rho2 = (1+(gamma-1)/2*M2^2)^(1/(gamma-1));
    T1 = (1+(gamma-1)/2*M1^2); a1 = sqrt(T1);
    T2 = (1+(gamma-1)/2*M2^2); a2 = sqrt(T2);
    P0 = P1/P2/P; T0 = T1/T2/T; rho0 = rho1/rho2/rho; a0 = sqrt(T0);
    entropy = log(P/rho^gamma);
    
    %% Check result
    check2 = zeros(1,6);
    if max(abs(f(result))) <= 1e-13; check2(1) = 1; end
    if M1 >= M1n && M1n >=1;  check2(2) = 1; end
    if M2n <= 1 && M2 >= M2n; check2(3) = 1; end
    if strcmp(condition,'super') && M2 >= 1; check2(4) = 1; end
    if strcmp(condition,'sub') && M2 <= 1; check2(4) = 1; end
    if beta >= 0 && beta <= 90 && delta >=0 && delta <= 70; check2(5) = 1; end
    if entropy >= 0; check2(6) = 1;end
    
    %% Display
    if all(check2);
        if beta < 89.9999;
            fprintf('===== Oblique Shock =====\n');
            fprintf('Condition: %ssonic \n',condition);
        elseif beta >= 89.9999;
            fprintf('===== Normal Shock =====\n');
        end
        fprintf('beta = %3.4f deg\n', beta);
        fprintf('delta = %3.4f deg\n', delta);
        fprintf('======================================================\n');
        fprintf('M1 = %3.4f, M1n = %3.4f \n', M1,M1n);
        fprintf('M2 = %3.4f, M2n = %3.4f \n', M2,M2n);
        fprintf('P2/P1 = %3.4f          (P)\n',P);
        fprintf('U2/U1 = %3.4f          (U)\n',U);
        fprintf('r2/r1 = %3.4f          (rho)\n',rho);
        fprintf('T2/T1 = %3.4f          (T)\n',T);
        fprintf('(U2n-U1n)/a1 = %3.4f  (dUn)\n',dUn)
        fprintf('(s2-s1)/Cv = %3.4f \n',entropy);
        fprintf('======================================================\n');
        fprintf('Stagnation Properties \n')
        fprintf('       01/1       02/2       01/02 \n');
        fprintf('P    %7.4f    %7.4f    %7.4f \n',P1,P2,P0);
        fprintf('rho  %7.4f    %7.4f    %7.4f \n',rho1,rho2,rho0);
        fprintf('T    %7.4f    %7.4f    %7.4f (Always 1) \n',T1,T2,T0);
        fprintf('a    %7.4f    %7.4f    %7.4f (Always 1) \n\n',a1,a2,a0);
        %% Calculate max delta
        f2 = @(M,b) M^4*sind(b)^2*(gamma+cosd(2*b)) - M^2*(gamma+cosd(2*b)-2*sind(b)^2) -2 - 0.5*sind(2*b)^2*M^4*(gamma+1);
        f2_1 = @(b) f2(M1,b);
        f2_2 = @(b) f2(M2,b);
        f_delta = @(M,b) atand( 2*cotd(b)*(M^2*sind(b)^2-1)/(2+M^2*(gamma+cosd(2*b))) );
        
        beta_maxdelta1 = fsolve(f2_1,89.99,options);
        delta_max1 = f_delta(M1,beta_maxdelta1);
        fprintf('max delta (M1) = %7.4f deg      (delta_max1)\n',delta_max1);
        if M2 >= 1;
            beta_maxdelta2 = fsolve(f2_2,89.99,options);
            delta_max2 = f_delta(M2,beta_maxdelta2);
            fprintf('max delta (M2) = %7.4f deg      (delta_max2)\n',delta_max2);
        end
        
        %% Failed Solution
    else fprintf('Solution Failed \n');
        if ~check2(1); disp('Solution did not converge, change initial guess');
        else
            if ~check2(2); fprintf('M1, M1n incorrect \nM1 = %3.4f, M1n = %3.4f \n',M1,M1n);end
            if ~check2(3); fprintf('M2, M2n incorrect \nM2 = %3.4f, M2n = %3.4f \n',M2,M2n);end
            if ~check2(4); fprintf('Condition not satisfied \n%ssonic, M2 = %3.4f \n',condition,M2);end
            if ~check2(5); fprintf('Beta/Delta not in range \nbeta = %3.4f deg, delta = %3.4f deg \n',beta,delta);end
            if ~check2(6); fprintf('Entropy Error\n(s2-s1)/Cv = %3.4f \n',entropy);end
        end
    end
    %% Input Failed
else
    disp('Input error');
end

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
% x(11) = dUn

