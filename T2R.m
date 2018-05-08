function R = T2R(T)

a = 3.9083E-03; 
b = -5.775E-07; 
c = -4.183E-12;

Tp = (T>=0).*T;
Tm = (T<0).*T;
R = 1000 + 1000.*( a.*Tp + b.*Tp.^2 ) + 1000.*( a.*Tm + b.*Tm.^2 + c.*(Tm-100).*Tm.^3 );

end