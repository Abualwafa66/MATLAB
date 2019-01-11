% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 6.  Anderson, second ed. Example 3.8 (p81)
%
% Air enters a constant-area duct at M1=0.2,p1=1 atm, T1=273K.  In the
% duct, heat is added at a rate (per unit mass) of q=1e6 J/kg.  Calculate
% the flow properties M2, P2, T2, rho2, T02, and P02 at the exit of the duct.

% initialize gaslab for air.  We don't need dimensional quantities (yet) so we
% leave the optional arugments out

gaslab(1.4);

% at the duct entrance
s = initstate(0.2);

% to comopute state 2, we use the process rayleigh.m, for which we 
% need to specify the ratio of stagnation temperature.  We have
%
% q = cp*(T02-T01)
%
% so if we know T01, and q, then we can compute T02, and hence T02/T01.
%
% first we get T01 (we'll also compute P01 while we're at it)

t01 = 273. / temp(s);
p01 = 1. / pres(s);

% while we have these, let's reinitilaze gaslab to have it use dimensional
% quantities
gaslab(1.4,p01,t01,28.97);

% we can get the ratio T0_rat = T02/T01
q = 1e6;
cp = 1005. ; % J/kg/K
t0_rat = (q/cp+t01)/t01;

% now we can perform the rayleigh process
s = rayleigh(s,t0_rat);

% and we can query the states to determine every property:

m = mach(s);
t0 = stagtemp(s); % this is redundant!
t = temp(s);
p0 = stagpres(s); % also redundant!
p = pres(s);
rho = density(s);

% in particular we have
disp(['At station 2:'])
disp(['Mach = ', num2str(m(2))]);
disp(['p = ', num2str(p(2)) ' atm']);
disp(['p0 = ', num2str(p0(2)) ' atm']);
disp(['t = ', num2str(t(2)) ' K']);
disp(['t0 = ', num2str(t0(2)) ' K']);
disp(['rho = ', num2str(rho(2)) ' kg/m^3']);

% As a further example, suppose that we now ask the question:  if we
% continue to add heat after station 2, how much heat can we add before the
% flow is choked (meaning that no further heat can be added in a steady
% flow with the same mass flow rate)

t03max = t0(2)/t0rcrit(s,2);
qmax = cp*(t03max-t0(2));

disp(['Maximum additional heat that could be added to choke flow is: ' num2str(qmax) ' J/kg/K'])




