% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 2.  Anderson, second ed. Example 5.2 (p163)
%
% A supersonic wind tunnel is designed to produce Mach 2.5 flow in the test
% section with standard sea level conditions.  Calculate the nozzle's exit area
% ratio (exit to throat) and reservoir conditions necessary to achieve these design
% conditions.

% initialize gaslab for air.  We don't need dimensional quantities (yet) so we
% leave the optional arugments out

gaslab(1.4);

% define the test section as the state

test = initstate( 2.5);

% the critical area ratio is

atest = arcrit(test);

% the pressure and temperature (relative to their stagnation values)

ptest = pres(test);
ttest = temp(test);

% so we have the following:

disp(['Ratio of test section to nozzle throat area = ' num2str(atest) ]);
disp(['Stagnation pressure required = ' num2str(1/ptest) ' times test section pres' ]);
disp(['Stagnation temperature required = ' num2str(1/ttest) ' times test section temp' ]);

% when we run this script the output is:

% >> example2
% Ratio of test section to nozzle throat area = 2.6367
% Stagnation pressure required = 17.0859 times test section pres
% Stagnation temperature required = 2.25 times test section temp


