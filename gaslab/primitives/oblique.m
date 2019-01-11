function [b,varargout] = oblique(m,th,g,strong)
%oblique  Solve theta-beta-m relationship for an oblique shock   

%    b = oblique(m,th,g) finds the angle b (radians) for a weak oblique shock
%    starting at a mach number, m, through a deflection angle th (radians).  
%    If th is greater than the maximum possible deflection, b is empty. g is 
%    the ratio of specific heats of a calorically perfect gas.
%
%    b = oblique(m,th,g,strong) finds the strong solution if strong==1,
%    otherwise it finds the weak solution
%
%    [b,mn1] = oblique(m,th,g,strong) also returns the incident mach number 
%    normal to the oblique shock, mn1.
%
%    [b,mn1,mn2] = oblique(m,th,g,strong) also returns the incident upstream 
%    and downstream mach numbers normal to the oblique shock, mn1 and mn2,
%    respectively.
%    
%    [b,mn1,mn2,m2] = oblique(m,th,g,strong) returns mn1 and mn2 as well as
%    the mach number in the direction of the flow downstream, m2.
    
    if th < 0 
        error('oblique: theta must be positive');
    end
    if m <= 1
        error('oblique: Mach number must be supersonic');
    end
        
    fun1 = @(z) ((4*m^2*cos(z)*cot(z)*sin(z))/...
    ((g + cos(2*z))*m^2 + 2) - (2*(cot(z)^2 + 1)*(m^2*sin(z)^2 - 1))/...
    ((g + cos(2*z))*m^2 + 2) + (4*m^2*sin(2*z)*cot(z)*(m^2*sin(z)^2 - 1))/...
    ((g + cos(2*z))*m^2 + 2)^2)/((4*cot(z)^2*(m^2*sin(z)^2 - 1)^2)/...
    ((g + cos(2*z))*m^2 + 2)^2 + 1);

%    fun1 = @(z) dthdb(m,z,g);
    bzero = fzero(fun1,[asin(1/m),pi/2]);
    thmax = tbm(m,bzero,g);
    
    if th > thmax
        b = [];
        if nargout > 1
            varargout{1} = [];
        end
        if nargout > 2
            varargout{2} = [];
        end
        if nargout > 3
            varargout{3} = [];
        end
    
        return
    end
    
    bmin = asin(1/m);
    bmax = pi/2;
    
    if nargin < 4 
        strong = 0;
    end
   
    fun = @(z) tan(th)-2*cot(z)*( m^2*sin(z)^2 - 1 ) / (m^2*(g+cos(2*z))+2);

    if strong
        b = fzero(fun,[bzero,bmax]);
    else
        b = fzero(fun,[bmin,bzero]);
    end
   
    mn1 = m*sin(b);
    mn2 = sqrt(( 1 + (g-1)*mn1^2/2)/ (g*mn1^2 - (g-1)/2));
    m2 = mn2/sin(b-th);
    
    if nargout > 1
        varargout{1} = mn1;
    end
    if nargout > 2
        varargout{2} = mn2;
    end
    if nargout > 3
        varargout{3} = m2;
    end
        

end