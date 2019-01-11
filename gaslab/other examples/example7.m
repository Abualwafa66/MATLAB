% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 7.  Anderson, second ed. Example 3.11 (p89)
%
% Air enters a constant-area pipe with diameter 0.15 m and length 30 m.  At
% the inlet, M1=0.3, p1 = 1atm, and T1 = 273k.  Suppose the average
% friction coefficient f = 0.005.  Calculate the flow conditions at the
% exit.

% initialize gaslab for air.  We don't need dimensional quantities (yet) so we
% leave the optional arugments out

gaslab(1.4);

% at the duct entrance
s = initstate(0.3);

% let's use the trick we used in Example 6, to get everything into
% dimensional quantities.  We compute the stagnation properties for state
% 1:

t01 = 273. / temp(s);
p01 = 1. / pres(s);

% and re-initialize gaslab with these as reservoir conditions.

gaslab(1.4,p01,t01,28.97);

% 
% compute the friction factor for this pipe
%
ffac = 4*0.005*30/0.15;

% now perform the Fanno process
s = fanno(s,ffac);

% and we can query the states to determine every property:

m = mach(s);
t0 = stagtemp(s); 
t = temp(s);
p0 = stagpres(s);
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

% Anderson appears to have made an error in his calculation for p (the rest
% are close (his rounding errors) to what is reported there)



