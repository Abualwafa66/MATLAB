function ar = arcrit(s, comp)
% arcrit   gaslab function for critical area ratio
%
%   ar = arcrit(s) computes the critical area ratio for Q1D, isentropic
%   flow for each of the flow states in s.
% 
%   ar = arcrit(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
%   see also areachg.m

    global gldef
    g = gldef.g;

    ar = arstar([s.m],g);
    
    if nargin > 1
        ar = ar(comp);
    end
    
end