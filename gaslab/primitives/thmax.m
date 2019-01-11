function th = thmax(m,g,small)

    large = 1/small;
    
    if m <= 1
        error('thetamax: Mach number must be supersonic');
    end
    if m >= large
        error('thetamax: Mach number overflow');
    end
        
    fun1 = @(z) ((4*m^2*cos(z)*cot(z)*sin(z))/...
    ((g + cos(2*z))*m^2 + 2) - (2*(cot(z)^2 + 1)*(m^2*sin(z)^2 - 1))/...
    ((g + cos(2*z))*m^2 + 2) + (4*m^2*sin(2*z)*cot(z)*(m^2*sin(z)^2 - 1))/...
    ((g + cos(2*z))*m^2 + 2)^2)/((4*cot(z)^2*(m^2*sin(z)^2 - 1)^2)/...
    ((g + cos(2*z))*m^2 + 2)^2 + 1);

%    fun1 = @(z) dthdb(m,z,g);
    bzero = fzero(fun1,[asin(1/m),pi/2]);
    th = tbm(m,bzero,g);
   
end