% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 3.  Anderson, second ed. Example 5.3 (p164)
%
% Rocket engine burning hydrogen and oxygen.  The combustion chamber temp.
% and pres. are 3517K and 25 atm, respectively.  The molecular weight of
% the gas is 16 and gamma=1.22.  The pressure at the exit of the CD rocket
% nozzle is 1.174e-2 atm.  The area of the throat is 0.4 m^2.  Assuming a
% CPG, calulate (a) the exit Mach number, (b) exit velocity,(c) the
% mass flow through the nozzle, and (d) the area of the exit

% initialize gaslab.  We supply the ratio of specific heats as first (required) argument.
% We also supply optional arguments as stagnatio pressure (in atm), stagation temperature 
% (in K), and moleular weight (in g/mol) so that we can get dimensional properties in the end

gaslab(1.22,25,3517,16);

% For the exit of the nozzle, we know the pressure, but we need the Mach number. 
% define a function handle and find the root (we know it should be
% supersonic)

pexit = 1.174e-2;
mfun = @(z)  pexit - pres( initstate( z ));
mexit =  fzero(mfun,[1,1e8]);
disp(['(a) The exit Mach number is ' num2str(mexit)])

% define the nozzle exit as the state and find its velocity
exit = initstate(mexit);
uexit = speed(exit);
disp(['(b) The exit velocity ' num2str(uexit) ' m/s '])

% We know the throat area of the nozzle but not the exit area.  Since the
% low is supersonic, the throat must be the critical area
athroat = 0.4;
aexit = athroat * arcrit(exit);
disp(['(d) The exit area ' num2str(aexit) ' m^2 '])

% the mass flow rate is rho*u*a
rhoexit = density(exit);
mdot = rhoexit*uexit*aexit;

disp(['(c) The mass flow rate is ' num2str(mdot) 'kg/s'])

