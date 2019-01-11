function r = density(s,comp)
% density   gaslab function for density
%
%   r = density(s) returns the temperature for each of the 
%   flow states in s.
% 
%   r = density(s,s_no) returns the result only for the state
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
        p0 = 1;
        con = 1;
    else
        t0 = gldef.resv.t0;
        p0 = gldef.resv.p0;
        con = 101325./gldef.resv.gcon;
    end
    
    p = pres(s);
    t = temp(s);
    r = con*( p ./t );
    
    if nargin > 1
        r = r(comp);
    end

end
    