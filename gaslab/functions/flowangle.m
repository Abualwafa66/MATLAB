function a = flowangle(s, comp)
% flowangle   gaslab function for flow angle
%
%   a = flowangle(s) returns the flow angle for each of the flow states in s.
% 
%   a = flowangle(s,s_no) returns the result only for the state
%   number s_no. 
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    a = [s.angle];
    
    if nargin > 1
        a = a(comp);
    end

end   
    