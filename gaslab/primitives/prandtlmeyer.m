function m2 = prandtlmeyer(m,th,g,small)
%prandtlmeyer Solve the Prandtl-Meyer relationship for a supersonic expansion
%   m2 = prandtlmeyer(m,th,g) finds the mach number, m2, downstream of an
%   isentropic expansion from a supersonic mach number, m, through a
%   deflection angle th (radians).  g is the ratio of specific heats of a
%   calorically perfect gas.
      
    if th < 0 
        error('prandtlmeyer: theta must be positive');
    end
    if m <= 1
        error('oblique: Mach number must be supersonic');
    end
    
    if th==0
        m2 = m;
    else
        
        numax = pi*( sqrt( (g+1)/(g-1)) - 1)/2;  
        num2 = th+pmnu(m,g);   
        fun = @(z) num2 - pmnu(z,g);     
        if num2 < numax
            m2 = fzero( fun,[m,1./small]);
        else
            m2 = [];
        end

    end
end