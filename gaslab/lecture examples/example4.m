% flat plate airfoil lift and drag

minf = 3;
g = 1.4;
gaslab(g);

top = @(alf) deflect(initstate(minf),-alf); % PM (work in rad).
bot = @(alf) deflect(initstate(minf),alf); % OS

ptop = @(alf) pres(top(alf),2)/pres(top(alf),1);  
pbot = @(alf) pres(bot(alf),2)/pres(bot(alf),1);

cd = @(alf) 2*sin(alf)*(pbot(alf) - ptop(alf) )/(g*minf^2);  % drag coef
cl = @(alf) 2*cos(alf)*(pbot(alf) - ptop(alf) )/(g*minf^2);  % lift coef

alfmax = thetamax(initstate(minf));
alf = linspace(1e-8,alfmax,100);
for k=1:length(alf)
  ccd(k) = cd(alf(k));
  ccl(k) = cl(alf(k));
end  
plot( 180*alf/pi, ccd,'r-', 180*alf/pi, ccl,'k-');

