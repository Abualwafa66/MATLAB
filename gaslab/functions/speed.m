function u = speed(s,comp)
% speed   gaslab function for velocity magnitude
%
%   u = speed(s) returns the velocity magnitude(flow speed) for each of the 
%   flow states in s.
% 
%   u = speed(s,s_no) returns the result only for the state
%   number s_no. 
%
%   The units of the output depend on how gaslab was initialized, see help
%   gaslab for more.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    if isempty(gldef.resv)
        con = 1;
    else
        con = gldef.g * gldef.resv.gcon;
    end
    
    a = sqrt( con*temp(s));
    u = [s.m] .* a;
    
    if nargin > 1
       u = u(comp);
    end
     
end