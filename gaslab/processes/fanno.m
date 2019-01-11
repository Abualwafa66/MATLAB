function s2 = fanno(s1,fric)
% fanno   gaslab process of quasi-one-dimensional, flow in a duct with friction.
%
%   s2 = fanno(s1,fric) appends a new state to the state list s1 (returned
%   in s2, which can be the same as s1) that is reached by a Fanno process
%   between the last state of s1 and the last state
%   of s2.  The argument fric is the non-dimensional friction factor,
%
%       fric = 4 f L / D where f is the friction coefficient, L length of
%       duct and D the hydraulic diameter
%
%   note the the function fcrit(s1) will query the state(s) and return the
%   critical friction factor corresponding to the maximum value that will
%   choke the flow (bring the Mach number to 1).  if a fric is larger than
%   frcit for the last state in s1, then a new state will not be appended.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%

    global gldef
    small = gldef.small;
    g = gldef.g;
    s2 = s1; % copy existing states
    
    
    f2 = fstar(s1(end).m,g)-fric;
    
    if f2 < 0
        return
    end
    
    if f2 < small
        s2(end+1).m = 1;
    else
        fun = @(z) f2-fstar(z,g);
        if s1(end).m <= 1
            s2(end+1).m = fzero(fun,[s1(end).m,1]);
        else
            s2(end+1).m = fzero(fun,[1,s1(end).m]);
        end
    end
    
    s2(end).p = s1(end).m*(pbyp0(s1(end).m,g)/pbyp0(s2(end).m,g)).^((g+1)/2/g)/s2(end).m;
    s2(end).t = 1;
    s2(end).angle = s1(end).angle;
    s2(end).proc = 'fanno';

end
    
        
        

