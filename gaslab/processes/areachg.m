function s2 = areachg(s1,ar,throat)
% areachg   gaslab process of quasi-one-dimensional, isentropic area change.
%
%   s2 = areachg(s1,ar) appends a new state to the state list s1 (returned
%   in s2, which can be the same as s1) that is reached by a Q1D,
%   isentropic area change between the last state of s1 and the last state
%   of s2 with area ratio ar (new area divided by old
%   area).
%
%   s2 = areachg(s1,ar,throat) includes an optional third argument which is
%   a flag that indicates that there is an area minimum between the old and
%   new states.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%

    global gldef
    small = gldef.small;
    g = gldef.g;
    
    s2 = s1;
    
    if nargin < 3
        throat = 0;
    end
    
    if throat 
        if s1(end).m < 1
            subsonic = 0;
        else
            subsonic = 1;
        end
    else
        if s1(end).m < 1
            subsonic = 1;
        else
            subsonic = 0;
        end
    end
       
    a2 = ar*arstar(s1(end).m,g);
      
    if a2 < 1
       return
    end
    
    if a2 < 1+small
        s2(end+1).m = 1;
    else
        fun = @(z) arstar(z,g)-a2;
        if subsonic
            s2(end+1).m = fzero(fun,[small,1]);
        else
            s2(end+1).m = fzero(fun,[1,1/small]);
        end
    end
    
    s2(end).p = 1;
    s2(end).t = 1;
    s2(end).angle = s1(end).angle;
    s2(end).proc = 'areachg';
   
end
    
        
        

