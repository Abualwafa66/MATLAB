function f = fcrit(s, comp)
% fcrit   gaslab function for critical friction factor
%
%   f = fcrit(s) computes critical friction factor for each of the flow states in s.
% 
%   f = fcrit(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
%   see also fanno.m

    global gldef
    g = gldef.g;

    f = fstar([s.m],g);
    
    if nargin > 1
        f = f(comp);
    end
    
end