function t = temp(s,comp)
% temp   gaslab function fortemperature
%
%   t0 = temp(s) returns the temperature for each of the 
%   flow states in s.
% 
%   t0 = temp(s,s_no) returns the result only for the state
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
    g = gldef.g;
    
    trat = tbyt0([s.m],g);
    t0 = t0*cumprod([s.t]);
    t = trat .* t0;
    
    if nargin > 1
       t = t(comp);
    end
    
end