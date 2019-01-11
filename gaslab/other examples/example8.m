% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 8.  Ae/ME 101b, homework problem 1.3, January 2018.
%
% A ramjet engine is designed to cruise at M=2 at an altitidue of 9 km.
% The engine consists of a CD diffuser, a constant-area combustion chamber,
% and a CD nozzle.
%
% The inlet-to-throat area ratio for the diffuser is 1.2, and the
% combustion chamber-to-diffuser throat area ratio is 2.5.  
% In the combustion chamber, fuel is injected at a rate of 1200 kJ/kg.  Ignore the mass of
% fuel added, compared to the mass flow of air in your anaylsis.  At
% critical operation, a normal shock sits at the throat of the inlet.
% Callulate the nozzle-to-inlet throat area ratio to obtain supersonic flow at the
% exit of the nozzle.

gaslab(1.4);

% it is easy enough to string together the processes

s = initstate(2);
s = areachg(s,1/1.2,0); % converging part of diffuser
s = normalshock(s); % shock at diffuser throat
s = areachg(s,2.5,0); % diverging part of diffuser

% to do the heat addition, we need to figure out the required stagnation
% temperature ratio.  We need to have the temperature of the air entering the 
% inlet.  From tables for the standard atmosphere, at an altitude of 9 km, the
% ambient temperature is 230k.  Similar to example 6, we compute
t01 = 230. / temp(s,1);
% note that there is no stag. temperature change up to station 4 (entrance
% to combustion chamber).
q = 1.2e6;
cp = 1004;
t0_rat = (q/cp+t01)/t01;

s = rayleigh(s,t0_rat);

% now, to accelerate the flow in the nozzle to supersonic speeds, the
% throat must be at the critical area corresponding to the state at the
% exit of the combustion chamber.

a_cc_by_a_nt = arcrit(s,5);

a_nt_by_a_it =  2.5 / a_cc_by_a_nt;

disp(['The required nozzle-throat to inlet-throat area ratio is ' num2str(a_nt_by_a_it)])



