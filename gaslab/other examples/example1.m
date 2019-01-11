% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 1.  Anderson, second ed. Example 5.1 (p163)
%
% Consider air flowing through a CD nozzle.  The resevoir pressure and temperautre are 10 atm
% and 300K, respectively.  There are two locations in the nozzle where
% A/A*=6, one in the convergent section and one in the divergent section.
% At each location, calculate M, p, T, and u.

% initialize gaslab.  We supply the ratio of specific heats as first (required) argument.
% We also supply optional arguments as stagnatio pressure (in atm), stagation temperature 
% (in K), and moleular weight (in g/mol) so that we can get dimensional properties in the end

gaslab(1.4,10,300,28.97);

% The function ar_crit_isen returns the ratio A/A* for a given state.
% Let's make a function handle to return A/A*-6 for a state of a given Mach
% number.  This function will be zero at the desired Mach number(s).

afun = @(z)  6.0 - arcrit( initstate( z ));

% in the converging/diverging section, the flow is subsonic/supersonic,
% let's look for the two roots

msub =  fzero(afun,[1e-8,1]);
msuper = fzero(afun,[1,1e8]);

% to find the remining quantities, we define 2 states correspoinding to the
% points where A/A* = 6

sub = initstate(msub);
super = initstate(msuper);

% we can now find everything else by querying the properties of the appropriate states

% for the converging side
psub = pres(sub);
tsub = temp(sub);
asub = soundsp(sub);
usub = speed(sub);

disp(['For converging part of nozzle, where A/A*=6'])
disp(['Pressure = ' num2str(psub) ' atm']);
disp(['Temperature = ' num2str(tsub) ' K']);
disp(['Sound speed = ' num2str(asub) ' m/s']);
disp(['Velocity = ' num2str(usub) ' m/s']);

% for the diverging side
psuper = pres(super);
tsuper = temp(super);
asuper = soundsp(super);
usuper = speed(super);

disp(['For converging part of nozzle, where A/A*=6'])
disp(['Pressure = ' num2str(psuper) ' atm']);
disp(['Temperature = ' num2str(tsuper) ' K']);
disp(['Sound speed = ' num2str(asuper) ' m/s']);
disp(['Velocity = ' num2str(usuper) ' m/s']);


% when we run this script the output is:

% >> example1
% For converging part of nozzle, where A/A*=6
% Pressure = 9.9344 atm
% Temperature = 299.4366 K
% Sound speed = 346.8544 m/s
% Velocity = 33.6435 m/s
% For converging part of nozzle, where A/A*=6
% Pressure = 0.15841 atm
% Temperature = 91.7849 K
% Sound speed = 192.035 m/s
% Velocity = 646.7493 m/s


