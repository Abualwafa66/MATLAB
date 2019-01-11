% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 4.  Anderson, second ed. Example 3.4 (p72)
%
% A normal shock wave is standing in the test section of a supersonic wind
% tunnel.  Upstream of the wave, M1=3, p1=0.5 atm, and T1=200K.  Find M2,
% p2, T2, a2, and u2 downstream of the wave.

% initialize gaslab for air.  We don't need dimensional quantities (yet) so we
% leave the optional arugments out

gaslab(1.4);

% initialize the upstream state

s = initstate(3);
s = normalshock(s);

m = mach(s);  % mach numbers of each state
prel = pres(s);   % ratio of pressures in each state relative to state 1 stagnation pressure
trel = temp(s);   % ratio of temperatures in each state relative to state 1 temperatures pressure

p1 = 0.5;  
p01 = p1/prel(1);  % find stag pressure of state 1
p = p01*prel;   % pressure of each state

t1 = 200;
t01 = t1/trel(1);  % find stag temp of state 1
t = t01*trel;

% to find velocity and sound speed, we could either do the formulas by
% hand, or use the speed.m and soundsp.m functions.  For the latter, we
% have to have initialized the stagnation pressure and temperature.  so
% let's reinitialize gaslab with these

gaslab(1.4,p01,t01,28.97);

u = speed(s);
a = soundsp(s);

% print out answer
disp('Upstream of shock:')
disp(['Mach = ' num2str(m(1)) ]);
disp(['Pressure = ' num2str(p(1)) ' atm' ]);
disp(['Temperature = ' num2str(t(1)) ' K']);
disp(['Sound speed = ' num2str(a(1)) ' m/s ']);
disp(['Velocity = ' num2str(u(1)) ' m/s ']);
disp('Downstream of shock:')
disp(['Mach = ' num2str(m(2)) ]);
disp(['Pressure = ' num2str(p(2)) ' atm' ]);
disp(['Temperature = ' num2str(t(2)) ' K']);
disp(['Sound speed = ' num2str(a(2)) ' m/s ']);
disp(['Velocity = ' num2str(u(2)) ' m/s ']);






