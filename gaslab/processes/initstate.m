function s = initstate(m)
% initstate   gaslab process to initialize a state list s
%
%   s = initstate(m) creates a state list of length 1 where the first 
%   state has a mach number m (>0), and subsequent states will be relative to 
%   this state.  The flow angle is initialized to zero (the first state
%   is the reference for zero degrees).
%
%   gaslab must be initialized (help gaslab) before using this routine.
% 
    if m < 0
        error('init: Mach number must be positive');
    end

    s.m = m;
    s.p = 1;
    s.t = 1;
    s.angle = 0;
    s.proc = 'initstate';
    
end
    
        
        