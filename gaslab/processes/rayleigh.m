function s2 = rayleigh(s1,t0r)
% rayleigh   gaslab process of quasi-one-dimensional, flow in a duct with heat transfer.
%
%   s2 = rayleigh(s1,t0r) appends a new state to the state list s1 (returned
%   in s2, which can be the same as s1) that is reached by a Rayleigh process
%   between the last state of s1 and the last state of s2.  The argument 
%   t0r is the desired ratio of stagnation temperatures between the old and new state.
%
%   t0r is related to the amount of heat transfered by the following
%   relation (t0r = T_02 / T_01)
%
%           q = c_p (T_02 - T_01)
%
%   note the the function t0rcrit(s1) will query the state(s) and return the
%   critical ratio of stagnation temperatures corresponding to the maximum value that will
%   choke the flow (bring the Mach number to 1). if a t0r is larger than
%   t0rcrit for the last state in s1, then a new state will not be appended.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%


    global gldef

    g = gldef.g;
    small = gldef.small;
    s2 = s1;
        
    f2 = t0r*t0star(s1(end).m,g);
    
    if f2 > 1
        return
    end
    
    if f2 > 1-small
        s2(end+1).m = 1;
    else
        fun = @(z) f2-t0star(z,g);
        if s1(end).m <= 1
            s2(end+1).m = fzero(fun,[s1(end).m,1]);
        else
            s2(end+1).m = fzero(fun,[1,s1(end).m]);
        end
    end
    
    s2(end).t = t0r;
    s2(end).p = (1+g*s1(end).m^2)*pbyp0(s1(end).m,g)/pbyp0(s2(end).m,g)/(1+g*s2(end).m^2);
    s2(end).angle = s1(end).angle;
    s2(end).proc = 'ra';
    
end
    
        
        

