clear all; close all; clc;
% function result = Nozzel(A)
%% Input: Ae/At; Pa/P0 (fixed input)
A = 2.1;   % Ratio between exit area and throat area
Pa0 = 0.2;  % Ratio between ambient pressure and 

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Calculate
gamma = 1.4;
options=optimset('MaxIter',3000,'MaxFunEvals',3000,'TolFun', 1.0e-14, 'TolX',1.0e-14,'Display','off');
f1 = @(M) 1/A - ((gamma+1)/2)^((gamma+1)/(2*gamma-2)) * M * (1+(gamma-1)/2*M^2)^(-(gamma+1)/2/(gamma-1));
M_sub = fsolve(f1,0,options);
M_super = fsolve(f1,1,options);
G = @(M) M*(1+(gamma-1)/2*M^2)^((gamma+1)/(2-2*gamma));
f_A = @(M) ((gamma+1)/2)^((gamma+1)/(2*gamma-2)) * M * (1+(gamma-1)/2*M^2)^(-(gamma+1)/2/(gamma-1));

%% Check answer
if M_sub >0 && M_sub < 1 && M_super >1 && abs(f1(M_sub))+abs(f1(M_super))<= 2e-12 && abs(G(M_sub)-G(M_super)) <= 1e-12
    disp('Solution Success');
    P0_sub = (1+(gamma-1)/2*M_sub^2)^(gamma/(gamma-1));
    P0_super = (1+(gamma-1)/2*M_super^2)^(gamma/(gamma-1));
    P0_crit = ((gamma+1)/2)^(gamma/(gamma-1));
    Pa = (2*gamma*M_super^2+1-gamma)/(gamma+1);
    M2 = sqrt((2+(gamma-1)*M_super^2)/(2*gamma*M_super^2+1-gamma));
    fprintf('\nNozzel Flow \n');
    disp('          _______  _______');
    disp('                 \/       ');
    disp('Chamber 0     Troat t    Exit e    Ambient a');
    disp('          _______/\_______');
    fprintf('\nAt thoat:(if chocked flow)\n');
    fprintf('P0/Pt = %7.4f, Pt/P0 = %7.4f, G/(r0*a0*At) = %7.4f \n\n',P0_crit,1/P0_crit,G(1));
    fprintf('At exit:\n');
    fprintf('Chocked Mass Flow Rate at Exit: G/(r0*a0*Ae) = %7.4f \n\nSubsonic Solution: (exatly chocked)\n',G(M_sub));
    fprintf('P0/Pe = %7.4f, Pe/P0 = %7.4f, M = %7.4f \n',P0_sub,1/P0_sub,M_sub);
    fprintf('Supersonic Solution: \n');
    fprintf('P0/Pe = %7.4f, Pe/P0 = %7.4f, M = %7.4f \n',P0_super,1/P0_super,M_super);
    fprintf('Normal Shock: \n');
    fprintf('Pa/Pe = %7.4f\nP0/Pa = %7.4f, Pa/P0 = %7.4f \n',Pa,P0_super/Pa,Pa/P0_super);
    fprintf('Exit Mach Number: M2 = %7.4f\n', M2);
    result = [A,1/P0_sub,M_sub,1/P0_super,M_super,Pa/P0_super,Pa,M2];
    %% Determine Properties for given Pa0
    if ~isempty(Pa0); 
        fprintf('\n\nSolution to Pa/P0 = %7.4f:\n',Pa0);
        if Pa0 > 1/P0_sub;
            disp('Subsonic Everywhere, Not Chocked');
            Me = sqrt(2/(gamma-1)*(Pa0^((1-gamma)/gamma)-1));
            Ge = G(Me); Ace = f_A(Me); Act = Ace*A; f2 = @(M) Act - f_A(M);
            Mt = fsolve(f2,0,options);
            if abs(G(Mt)-Ge*A) <= 1e-12;
                fprintf('Me = %7.4f, Ac/Ae = %7.4f\n',Me,Ace);
                fprintf('Mass Flow Rate at Exit: G/(r0*a0*Ae) = %7.4f\n',Ge);
                fprintf('Mt = %7.4f, Ac/At = %7.4f\n',Mt,Act);
                fprintf('Mass Flow Rate at throat: G/(r0*a0*At) = %7.4f\n',G(Mt));
            else disp('Error in solving Mt');
            end
        end
        if Pa0 == 1/P0_sub; 
            disp('Chocked Flow, subsonic solution'); 
        end
        if Pa0 < 1/P0_sub && Pa0 > Pa/P0_super; 
            disp('Upstream Shock'); 
        end
        if Pa0 == Pa/P0_super; 
            disp('Normal Shock');
            fprintf('\nM1 = %10.7f;\nbeta = 90;\ncondition = ''sub'';\n',M_super); 
        end
        if Pa0 < Pa/P0_super && Pa0 > 1/P0_super; 
            disp('Oblique Shock (Use shock.m for detailed solution)');
            fprintf('\nM1 = %10.7f;\nP = %10.7f;\ncondition = ''super'';\n',M_super,Pa0*P0_super); 
        end
        if Pa0 == 1/P0_super; 
            disp('Supersonic Jet, Supersonic Solution');
        end
        if Pa0 < 1/P0_super; 
            disp('PM Expansion (Use PME.m for detailed solution)'); 
            fprintf('\nM1 = %10.7f;\nP = %10.7f;\n',M_super,Pa0*P0_super);
        end
    end
else disp('Solution Failed');
end

