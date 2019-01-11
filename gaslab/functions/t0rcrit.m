function t0r = t0rcrit(s, comp)
% t0rcrit   gaslab function for critical stagnation temperature ratio
%
%   t0r = t0rcrit(s) computes critical stagnation temperature ratio
%   for each of the flow states in s.
% 
%   t0r = t0rcrit(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
%   see also rayleigh.m

    global gldef
    g = gldef.g;
    
    t0r = t0star([s.m],g);
    
    if nargin > 1
        t0r = t0r(comp);
    end
    
end