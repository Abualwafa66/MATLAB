% Prandtl-Meyer expansion.  What angle of deflection is required to expand
% the flow from 1 atm to 0.1 atm?

gaslab(1.4);
m3 = 4;

% using the deflect routine is iterative for this problem

% set up function handles
st = @(ang) deflect(initstate(m3),-pi*ang/180); % note the - sign
prat = @(ang) pres(st(ang),2)/pres(st(ang),1);
zfun = @(ang) prat(ang)-0.1;

% find the zero of zfun (brakcet the root between 0 and 40 degrees)
theta = fzero(zfun,[1e-8 40])

