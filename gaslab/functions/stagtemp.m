function t0 = stagtemp(s,comp)
% stagtemp   gaslab function for stagnation temperature
%
%   t0 = stagtemp(s) returns the stagnation temperature for each of the 
%   flow states in s.
% 
%   t0 = stagtemp(s,s_no) returns the result only for the state
%   number s_no. 
%
%   The units of the output depend on how gaslab was initialized, see help
%   gaslab for more.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    
    if isempty(gldef.resv)
        t0 = 1;
    else
        t0 = gldef.resv.t0;
    end
    
    t0 = t0*cumprod([s.t]);
    
    if nargin > 1
        t0 = t0(comp);
    end

end