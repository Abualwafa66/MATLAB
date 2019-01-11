function m = mach(s, comp)
% mach   gaslab function for Mach number
%
%   m = mach(s) returns the mach number for each of the flow states in s.
% 
%   m = mach(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    m = [s.m];
    
    if nargin > 1
        m = m(comp);
    end

end   
    