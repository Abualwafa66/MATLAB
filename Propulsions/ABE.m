%{
This script is written mainly for UCSD MAE113 propulsions by Yuting Huang.
It calculates different parameters for Air Breathing Engines based on given
parameters.
Types of engines include Ramjet, Turbojet, Turbofan and Turboprop.
Only change parameters between the two seperations.
%}
%% Initialize (DO NOT CHANGE)
clear all; close all; clc;
e_diffuser = 1; e_fan = 1; e_compressor = 1; e_burning = 1; r_combustor = 1;
e_turbine = 1; e_nozzel = 1; e_nozzelfan = 1; e_prop = 1; e_gear = 1; e_powerturbine = 1;

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Below this speration and above the next speration are the parameters need to be changed
Prc = 1;     % Compressor Pressure Ratio (1 for ramjet)
B = 0;       % Bypass Ratio (0 for ramjet, turbojet, turboshaft)
Prf = 1;     % Pressure Ratio of fan 
             %(1 for ramjet, turbojet, turboshaft, aka, no fan)
T_after = 1; % Stagnation Pressure ratio before and after Afterburner
             % (1 for without afterburner)
alpha = 0;   % Enthalpy ratio for turboprop

%% Design Parameters 
M  = 1.5;                      % Flight Mach Number
T4a  = 7;                      % T = To4/Ta Peak Temperature
g  = 1.3;                      % gamma
Rg = 287; Cp = g/(g-1)*Rg;     % Gas Constant for air (J/kg K)
Ta = 260;  aa = sqrt(g*Rg*Ta); % Atmospheric Temperature (K), Atmospheric air speed (m/s)
aa = 300;
Qr = 45e6;                     % Fuel Formation Heat (J/kg)
Q  = Qr/Cp/Ta;
Q = 200;

%% !!! The following secitons should be uncommented for the type of engine
%% wished to calculate, the other types should be commented !!!!!
%% Ramjet
% e_diffuser = 0.8; e_burning = 1; r_combustor = 0.95; e_nozzel = 0.95;

%% Turbojet
%
e_diffuser = 1; e_compressor = 1; e_burning = 1; 
r_combustor = 1; e_turbine = 1; e_nozzel = 1;
Prc = 20;
T_after = 1;
%
%% Turbofan
%{
e_diffuser = 1; e_fan = 0.85; e_compressor = 0.85; e_burning = 1; r_combustor = 1;
e_turbine = 0.95; e_nozzel = 1; e_nozzelfan = 1;
Prc = 15; B = 3; Prf = 1.5;
T_after = 3;
%}
%% Turboprop
%{
e_diffuser = 0.98; e_compressor = 0.85; e_burning = 1; 
r_combustor = 1; e_turbine = 0.95; e_nozzel = 1;
e_prop = 0.8; e_gear = 0.93; e_powerturbine = 0.96;
Prc = 15; alpha = 1;
%}
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Engine Type
disp('Air Breathing Engines');
if B ~= 0; fprintf('Turbofan\n'); type = 1;
elseif Prc ~= 1 && alpha ==0; fprintf('Turbojet\n'); type = 2;
elseif Prc == 1; fprintf('Ramjet\n'); type = 3;
elseif Prc ~= 1 && alpha ~=0; fprintf('Turboprop\nalpha = %f\n',alpha); type = 4;
end
%% Calculation
T54 = 1 - ( ( Prc^((g-1)/g)-1 )/e_compressor + B*( Prf^((g-1)/g)-1 )/e_fan ) ...
    *(1+(g-1)/2*M^2)/T4a; % T5/T4
f = ( T4a -(1+(Prc^((g-1)/g)-1)/e_compressor)*(1+(g-1)/2*M^2) ) ...
    /( e_burning*Q - T4a ); % Ratio of Mass Flow Rate of fuel over air
Ue = sqrt((e_nozzel*T_after*T54*T4a*(1- ( ...
    (1-(1-T54)/e_turbine)*(r_combustor*Prc)^((g-1)/g)*(1+e_diffuser*(g-1)/2*M^2) ...
    )^(-1) ))*2/(g-1)) *aa; % Ue Exit Velocity of hot jet (m/s)
Uef = sqrt((e_nozzelfan*(1+(Prf^((g-1)/g)-1)/e_fan)*(1+(g-1)/2*M^2)*(1- ( ...
    Prf^((g-1)/g)*(1+e_diffuser*(g-1)/2*M^2) ...
    )^(-1) ))*2/(g-1)) *aa; % Uef Exit Velocity of cold stream (m/s)

T2a = 1+(g-1)/2*M^2; P2a = (e_diffuser*(T2a-1)+1)^(g/(g-1)); % Diffuser
T32 = ( Prc^((g-1)/g)-1 )/e_compressor+1; P32 = Prc;         % Compressor
T43 = T4a/T32/T2a; P43 = r_combustor;                        % Combustor 
P54 = (1-(1-T54)/e_turbine)^(g/(g-1));                       % Turbine
P72 = Prf; T72 = 1 + (Prf^((g-1)/g) -1)/e_fan;               % Fan
T6a = T_after*T54*T4a - (g-1)/2*(Ue/aa)^2;                   % Hot Nozzel
T8a = T72*T2a - (g-1)/2*(Uef/aa)^2;                          % Cold Nozzel

Tma = ((1+f)*Ue/aa + B*Uef/aa - (1+B)*M)*aa;
if type == 4;  % Special case for Turboprop
    delta_h = Cp*Ta*T54*T4a*(1-(P54*P43*P32*P2a)^((1-g)/g));
    Ue = 2*sqrt(2*e_nozzel*(1-alpha)*delta_h);
    Tma = (1+f)*Ue - M*aa + e_prop*e_gear*e_powerturbine*(1+f)*alpha*delta_h/M/aa;
    T6a = T54*T4a - e_powerturbine*alpha*delta_h/Cp/Ta;       % Power Turbine
    T7a = T6a - (g-1)/2*(Ue/aa)^2;
    Pspt = e_powerturbine*alpha*(1+f)*delta_h;
end
TSFC = f/Tma;
e_prop = 2*Tma*M/aa/( (1+f)*(Ue/aa)^2 - M^2 );
e_ther = (g-1)/2*( (1+f)*(Ue/aa)^2 - M^2 )/f/Q;
e_tot  = (g-1)*Tma*M/aa/f/Q;

%% Dispplay
if T_after ~= 1;
    fprintf('With AfterBurner, stagnation temperature ratio %5.3f\n',T_after);
end
switch type
    case 2
        disp(' _________________  ____');
        disp('/    ||3    4|5   \/    ');
        disp(' 2   ||======|        6 ');
        disp('\____||______|____/\____');
    case 3
        disp(' _________________  ____');
        disp('/         f   5   \/    ');
        disp(' 2                    6 ');
        disp('\_________________/\____');
    case 1
        disp('  _______________  ____');
        disp(' / |  7          \/  8 ');
        disp('/  |_____________  ____');
        disp('   |||3    4|5   \/    ');
        disp(' 2 |||======|        6 ');
        disp('   |||______|____/\____');
        disp('\  |                   ');
        disp(' \_|_____________/\____');
    case 4
        disp('   ______________________  ____');
        disp('  /    ||3    4|5  |6    \/     ');
        disp('---2---||======|---|         7 ');
        disp('  \____||______|___|_____/\_____');
end


fprintf('\nQr/(Cp Ta) = %11.5f\n\n',Q);
fprintf('f      = %9.7f\n',f);
if type ~= 4;
fprintf('Ue/aa  = %8.5f,  Me  = %8.5f,  Ue  = %11.5f (m/s)\n',Ue/aa,Ue/aa/sqrt(T6a),Ue);
else fprintf('Ue/aa  = %8.5f,  Me  = %8.5f,  Ue  = %11.5f (m/s)\n',Ue/aa,Ue/aa/sqrt(T7a),Ue);
end
if type ==1; fprintf('Uef/aa = %8.5f,  Mef = %8.5f,  Uef = %11.5f (m/s)\n',Uef/aa,Uef/aa/sqrt(T8a),Uef); end
fprintf('T/ma   = %11.5f (m/s)\n',Tma);
fprintf('TSFC   = %12.5E (s/m)\n\n',TSFC);
if type ~= 1 && type ~= 4;
    fprintf('Propulsion Effeciency = %7.5f\n',e_prop);
    fprintf('Thermal    Effeciency = %7.5f\n',e_ther);
end
fprintf('Total      Effeciency = %7.5f\n\n\n',e_tot);

switch type
    case 2
        fprintf('To2/Ta = %9.5f, To3/To2 = %9.5f, To4/To3 = %9.5f, To5/To4 = %9.5f, T6/Ta = %9.5f\n',T2a,T32,T43,T54,T6a);
        fprintf('Po2/Pa = %9.5f, Po3/Po2 = %9.5f, Po4/Po3 = %9.5f, Po5/Po4 = %9.5f\n',P2a,P32,P43,P54);
    case 3
        fprintf('To2/Ta = %9.5f, To5/To2 = %9.5f, T6/Ta = %9.5f\n',T2a,T32*T43*T54,T6a);
        fprintf('Po2/Pa = %9.5f, Po5/Po2 = %9.5f\n',P2a,P32*P43*P54);
    case 1
        fprintf('     To7/To2 = %9.5f, Po7/Po2 = %9.5f, T8/Ta = %9.5f\n',T72,P72,T8a);
        fprintf('To2/Ta = %9.5f, To3/To2 = %9.5f, To4/To3 = %9.5f, To5/To4 = %9.5f, T6/Ta = %9.5f\n',T2a,T32,T43,T54,T6a);
        fprintf('Po2/Pa = %9.5f, Po3/Po2 = %9.5f, Po4/Po3 = %9.5f, Po5/Po4 = %9.5f\n',P2a,P32,P43,P54);
    case 4
        fprintf('delta_h = %9.5f (J/kg), Pspt/ma = %9.5f (J/kg), Pspt/(ma U^2) = %9.5f\n',delta_h,Pspt,Pspt/(M*aa)^2);
        fprintf('To2/Ta = %9.5f, To3/To2 = %9.5f, To4/To3 = %9.5f, To5/To4 = %9.5f, To6/Ta = %9.5f, T7/Ta = %9.5f\n',T2a,T32,T43,T54,T6a,T7a);
        fprintf('Po2/Pa = %9.5f, Po3/Po2 = %9.5f, Po4/Po3 = %9.5f, Po5/Po4 = %9.5f\n',P2a,P32,P43,P54);
end

