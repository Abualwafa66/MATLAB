% Prandtl-Meyer expansion with an angle of 30 degrees (air), starting with
% M1=2

gaslab(1.4);
m1 = 2;
ang = -30*pi/180; 
s = initstate(m1); % - sign for expansion
s = deflect(s,ang);

m2 = mach(s,2)

p = pres(s,2)/pres(s,1)
