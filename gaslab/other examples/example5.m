% Gaslab examples
% c. Tim Colonius, Caltech 2018
%
% Example 5.  Anderson, second ed. Example 3.6 (p73)
%
% A Pitot probe is placed in a supersonic air stream where the static pressure is
% 0.4 atm.  The pressure measured by the tube is 3 atm.  Find the Mach
% number

% initialize gaslab for air.  We don't need dimensional quantities (yet) so we
% leave the optional arugments out

gaslab(1.4);

% The Pitot probe registers the stagnatino pressure of the flow near its tip.  But
% when placed in a supersonic stream, a bow shock forms ahead of the tip,
% resulting in losses.  We model the shock as normal near the tip.  If the
% Mach number upstream is z, then the stagnation pressure upstream is

p01 = @(z) 0.4/pres(initstate(z)); %  p1 / (p1/p01)

% and downstream stagnation pressure is

p02 = @(z) stagpres(normalshock(initstate(z)),2) * p01(z);

% not that in call to stagpres, we give the optional second argument to
% select the second state from the 2-state list

% thus the function we need to solve is

pfun = @(z) 3 - p02(z);

m1 = fzero(pfun,[1,1e8]);

disp(['The mach number of the stream is ' num2str(m1)])





