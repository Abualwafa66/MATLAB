function b = beta(s, comp)
% thetamax   gaslab function for maximum deflection angle
%
%   b = beta(s) returns the oblique shock angle for each of the 
%   flow states in s that were obtained by an oblique shock from
%   the previous state.  If the state was reached in some other way
%   (or if it is the initial state), beta does not exist and -Inf is returned.
% 
%   b = beta(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    g = gldef.g;
    
    m = [s.m];

    b = zeros(size(m));
    
    b(1) = -Inf;  % initial state 
    
    for k=2:length(s)
        ang = abs( s(k).angle - s(k-1).angle );
        if m(k) <= m(k-1) && m(k-1) >=1 && ang ~=0
            zfun = @(z) ns( m(k-1)*sin(z), g)-m(k)*sin(z-ang);            
            b(k) = fzero(zfun,[asin(1/m(k-1)) pi/2]);
        else
            b(k) = -Inf;
        end
    end
        
    if nargin > 1
        b = b(comp);
    end
    
end