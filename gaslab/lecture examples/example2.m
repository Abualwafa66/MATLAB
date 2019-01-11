% Prandtl-Meyer expansion

gaslab(1.4);
m1 = 2;
ang = -30*pi/180; 

sright = deflect(initstate(m1),-ang,-1);  % rightgoing PM
sleft = deflect(initstate(m1),ang,1); % leftgoing PM

% the states in sright and sleft are identical!

mach(sright)-mach(sleft)