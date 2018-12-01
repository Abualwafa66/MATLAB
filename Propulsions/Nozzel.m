%{
This script is written mainly for UCSD MAE113 propulsions by Yuting Huang.
For given Nozzel shape (Ae/At) (Exit Area/Throat area),
It calculates the pressure ratios (Pa/P0) (Ambient Pressure/Chamber Pressure)
for three dividing situations.
It then uses the given pressure ratio to determine which situation the flow
is.
%}
clear all; close all; clc;
% function result = Nozzel(A)
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Input: Ae/At; Pa/P0 (fixed input)
% Ratio between exit area and throat area (Ae/At);
A = 1.1;  
% Ratio between ambient pressure and stagnation pressure (Pa/P0);
Pa0 = 101.325/191.8;  

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Setup
gamma = 1.4;
options=optimset('MaxIter',6000,'MaxFunEvals',6000,'TolFun', 1.0e-15, 'TolX',1.0e-15,'Display','off');
%% Equations
f1 = @(M) 1/A - ((gamma+1)/2)^((gamma+1)/(2*gamma-2)) * M * (1+(gamma-1)/2*M^2)^(-(gamma+1)/2/(gamma-1));
G = @(M) M*(1+(gamma-1)/2*M^2)^((gamma+1)/(2-2*gamma));
f_A = @(M) ((gamma+1)/2)^((gamma+1)/(2*gamma-2)) * M * (1+(gamma-1)/2*M^2)^(-(gamma+1)/2/(gamma-1));
%% Calculate Subsonic and Supersonic Conditions for Given Nozzel Shape
if A == 1; M_sub = 1; M_super = 1;
else M_sub = fsolve(f1,0,options); M_super = fsolve(f1,1,options);
end
%% Check answer
if M_sub >0 && M_sub <= 1 && M_super >= 1 && abs(f1(M_sub))+abs(f1(M_super))<= 2e-12 && abs(G(M_sub)-G(M_super)) <= 1e-12
    P0_sub = (1+(gamma-1)/2*M_sub^2)^(gamma/(gamma-1));
    P0_super = (1+(gamma-1)/2*M_super^2)^(gamma/(gamma-1));
    P0_crit = ((gamma+1)/2)^(gamma/(gamma-1));
    Pa = (2*gamma*M_super^2+1-gamma)/(gamma+1);
    M2 = sqrt((2+(gamma-1)*M_super^2)/(2*gamma*M_super^2+1-gamma));
    disp('        === Nozzel Flow === ');
    disp('    _____________  __________');
    disp('                 \/       ');
    disp('Chamber 0     Troat t    Exit e      Ambient a');
    disp('    _____________/\__________');
    fprintf('==================================================================\n');
    fprintf('For Choked Flow At thoat: (These are constants)\n');
    fprintf('P0/Pt = %7.4f, Pt/P0 = %7.4f, G/(r0*a0*At) = %7.4f \n',P0_crit,1/P0_crit,G(1));
    fprintf('For Choked Flow At exit:\n');
    fprintf('Chocked Mass Flow Rate at Exit: G/(r0*a0*Ae) = %7.4f \n',G(M_sub));
    fprintf('==================================================================\n');
    fprintf('==================================================================\n');
    fprintf('Highest Pa/P0                                     Lowest Pa/P0\n');
    fprintf('|   (1)    |   (2)  |  (3)   | (4)  |  (5)  |   (6)    | (7) |\n')
    fprintf('| Subsonic |Subsonic|Upstream|Normal|Oblique|Supersonic| PME |\n')
    fprintf('|Everywhere|Chocked | Shock  |Shock | Shock |   Jet    |     |\n')
    fprintf('==================================================================\n');
    fprintf('(2). To Have Exactly Chocked Subsonic Flow:\n');
    fprintf('P0/Pe = %7.4f, Pe/P0 = %7.4f, Me = %7.4f \n',P0_sub,1/P0_sub,M_sub);
    fprintf('==================================================================\n');
    fprintf('(4). To have Normal Shock at exit: \n');
    fprintf('Pa/Pe = %7.4f\nP0/Pa = %7.4f, Pa/P0 = %7.4f \n',Pa,P0_super/Pa,Pa/P0_super);
    fprintf('Mach Number Behind Shock: M2 = %7.4f\n', M2);
    fprintf('==================================================================\n');
    fprintf('(6). To Have Supersonic Jet: \n');
    fprintf('P0/Pe = %7.4f, Pe/P0 = %7.4f, Me = %7.4f \n',P0_super,1/P0_super,M_super);
    fprintf('==================================================================\n');
    fprintf('==================================================================\n');
    result = [A,1/P0_sub,M_sub,1/P0_super,M_super,Pa/P0_super,Pa,M2];
    %% Determine Properties for given Pa0
    tolerance = 1e-5;
    if ~isempty(Pa0); 
        fprintf('Solution to input: Pa/P0 = %7.4f:\n',Pa0);
        if Pa0 - 1/P0_sub > tolerance;
            disp('Subsonic Everywhere, Not Chocked');
            Me = sqrt(2/(gamma-1)*(Pa0^((1-gamma)/gamma)-1));
            Ge = G(Me); Ace = f_A(Me); Act = Ace*A; f2 = @(M) Act - f_A(M);
            Mt = fsolve(f2,0,options);
            if abs(G(Mt)-Ge*A) <= 1e-10;
                fprintf('Me = %7.4f, Ac/Ae = %7.4f\n',Me,Ace);
                fprintf('Mass Flow Rate at Exit: G/(r0*a0*Ae) = %7.4f\n',Ge);
                fprintf('Mt = %7.4f, Ac/At = %7.4f\n',Mt,Act);
                fprintf('Mass Flow Rate at throat: G/(r0*a0*At) = %7.4f\n',G(Mt));
            else Mt = fsolve(f2,1,options);
                if abs(G(Mt)-Ge*A) <= 1e-10;
                    fprintf('Me = %7.4f, Ac/Ae = %7.4f\n',Me,Ace);
                    fprintf('Mass Flow Rate at Exit: G/(r0*a0*Ae) = %7.4f\n',Ge);
                    fprintf('Mt = %7.4f, Ac/At = %7.4f\n',Mt,Act);
                    fprintf('Mass Flow Rate at throat: G/(r0*a0*At) = %7.4f\n',G(Mt));
                else
                    disp('Error in solving Mt');
                end
            end
        end
        if abs(Pa0 - 1/P0_sub) <= tolerance; 
            disp('Exactly Chocked Subsonic Flow, subsonic solution'); 
        end
        if Pa0 - 1/P0_sub < tolerance && Pa0 - Pa/P0_super > tolerance; 
            disp('Upstream Shock'); 
        end
        if abs(Pa0 - Pa/P0_super) <= tolerance; 
            disp('Normal Shock At Exit');
            fprintf('\nM1 = %10.7f;\nbeta = 90;\ncondition = ''sub'';\n',M_super); 
        end
        if Pa0 - Pa/P0_super < tolerance && Pa0 - 1/P0_super > tolerance; 
            disp('Oblique Shock At Exit (Use shock.m for detailed solution)');
            fprintf('\nM1 = %10.7f;\nP = %10.7f;\ncondition = ''super'';\n',M_super,Pa0*P0_super); 
        end
        if abs(Pa0 - 1/P0_super) <= tolerance; 
            disp('Supersonic Jet (No Shock, No PME), Supersonic Solution');
        end
        if Pa0 - 1/P0_super < tolerance; 
            disp('PM Expansion At Exit (Use PME.m for detailed solution)'); 
            fprintf('\nM1 = %10.7f;\nP = %10.7f;\n',M_super,Pa0*P0_super);
        end
    end
else disp('Solution Failed');
end

