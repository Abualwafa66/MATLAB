function p = pres(s,comp)
% pres   gaslab function for pressure
%
%   p0 = pres(s) returns the pressure for each of the 
%   flow states in s.
% 
%   p0 = pres(s,s_no) returns the result only for the state
%   number s_no. 
%
%   The units of the output depend on how gaslab was initialized, see help
%   gaslab for more.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    g = gldef.g;
    
    if isempty(gldef.resv)
        p0 = 1;
    else
        p0 = gldef.resv.p0;
    end
    
    prat = pbyp0([s.m],g);
    p0 = p0*cumprod([s.p]);
    p = prat .* p0;
    
    if nargin > 1
        p = p(comp);
    end

end   
