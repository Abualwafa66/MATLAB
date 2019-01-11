function a = soundsp(s,comp)
% soundsp   gaslab function for sound speed
%
%   a = soundsp(s) returns the sound speed for each of the 
%   flow states in s.
% 
%   a = soundsp(s,s_no) returns the result only for the state
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
    
    if nargin > 1
       a = a(comp);
    end
    
     
end
    
     
    
    