function s2 = normalshock(s1)
% normalshock   gaslab process for a normal shock wave
%
%   s2 = normalshock(s1) appends a new state to the state list s1 (returned
%   in s2, which can be the same as s1) that is reached by a normal shock
%   between the last state of s1 and the last state of s2.
%
%   if the mach number of the last state is not supersonic (> 1) a new
%   state will not be appended (s2 will be a copy of s1). d
%
%   gaslab must be initialized (help gaslab) before using this routine.
%

    global gldef
    g = gldef.g;
    small = gldef.small;
    
    s2 = s1; % copy states
            
    if  s1(end).m < 1
        warning('normalshock: M > 1 is required; no state added');
        return
    end
    
    if s1(end).m < 1+small
        s2(end+1).m = 1;
    else
        s2(end+1).m = ns(s1(end).m,g);
    end

    s2(end).t = 1;
    s2(end).p = nspr(s1(end).m,g)*pbyp0(s1(end).m,g)/pbyp0(s2(end).m,g);
    s2(end).angle = s1(end).angle;
    s2(end).proc = 'normalshock';
    
end
    
        
        

