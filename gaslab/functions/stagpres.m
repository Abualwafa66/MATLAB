function p0 = stagpres(s,comp)
% stagpres   gaslab function for stagnation pressure
%
%   p0 = stagpres(s) returns the stagnation pressure for each of the 
%   flow states in s.
% 
%   p0 = stagpres(s,s_no) returns the result only for the state
%   number s_no. 
%
%   The units of the output depend on how gaslab was initialized, see help
%   gaslab for more.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    
    if isempty(gldef.resv)
        p0 = 1;
    else
        p0 = gldef.resv.p0;
    end
    
    p0 = p0*cumprod([s.p]);

    if nargin > 1
        p0 = p0(comp);
    end
 
end