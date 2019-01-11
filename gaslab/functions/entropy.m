function ent = entropy(s,comp)
% entropy   gaslab function for entropy 
%
%   ent = entropy(s) returns the temperature for each of the 
%   flow states in s.
% 
%   ent = entropy(s,s_no) returns the result only for the state
%   number s_no. 
%
%   The units of the output are always relative, dimensionless forn as 
%   (ent-ent_1)/cp, where ent_1 is the entropy of the first state in the list.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    
    if isempty(gldef.resv)
        t0 = 1;
        p0 = 1;
    else
        t0 = gldef.resv.t0;
        p0 = gldef.resv.p0;
    end
    g = gldef.g;
    fac = (g-1)/g;
    
    t = temp(s)/t0;  
    p = pres(s)/p0;
    
    ent = log( t) - fac*log( p);
    
    if nargin > 1
       ent = ent(comp);
    end
    
end