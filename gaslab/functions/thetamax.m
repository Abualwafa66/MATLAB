function th = thetamax(s, comp)
% thetamax   gaslab function for maximum deflection angle
%
%   th = thetamax(s) returns the maximum deflection angle each of the 
%   flow states in s.  If the Mach number of a state is subsonic, the angle
%   does not exist and -Inf is returned.
% 
%   th = thetamax(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    g = gldef.g;
    
    m = [s.m];
    th = zeros(size(m));
    
    for k=1:length(m)
        if m(k) < 1
            th(k) = -Inf;
        else
            th(k) = thmax(m(k),g,gldef.small);
        end
    end
    
    if nargin > 1
        th = th(comp);
    end
    
end