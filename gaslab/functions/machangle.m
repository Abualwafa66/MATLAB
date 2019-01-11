function mu = machangle(s, comp)
% machangle   gaslab function for critical area ratio
%
%   mu = machangle(s) computes mach angle for each of the flow states in s.
% 
%   mu = machangle(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%

    m = [s.m];
    mu = asin(1./m);
    mu(m<1) = -Inf;
    
    if nargin > 1
        mu = mu(comp);
    end

end   
    