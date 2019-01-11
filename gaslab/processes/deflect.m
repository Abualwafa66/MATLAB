function s2 = deflect(s1,ang,fam,strong)
% deflect   gaslab process for deflecting a supersonic stream
%
%   s2 = deflect(s1,ang) appends a new state to the state list s1 (returned
%   in s2, which can be the same as s1) that is reached by either an
%   oblique shock (ang > 0) or Prandtl-Meyer expansion (ang < 0).  If
%   mach(s1,end)<1, no new state will be appended.
%
%   s2 = deflect(s1,ang,fam) specifies the wave family fam = +1 for
%   leftgoing wave, and -1 for rightgoing wave.  Then the signed angle
%   determines whether it is an OS or PM.
%
%   s2 = deflect(s1,ang,fam,strong) specifies that the strong OS solution should
%   be used (default is the weak solution).
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    g = gldef.g;
    s2 = s1;  % copy existing states
    
    if nargin == 2
        fam = 1;
        strong = 0;
    elseif nargin == 3
        strong = 0;
    end
    
    if s1(end).m < 1
        warning('delect: M > 1 is required for supersonic flow turning; no state added');
        return
    end
    
    if ang*fam > 0 % compression
        
        [beta,mn1,~,m2] = oblique(s1(end).m,abs(ang),g,strong);  
        if isempty(beta)
            warning('deflect: no oblique shock solution (M to low or angle to high); no state added');
            return
        end
        s2(end+1).m = m2;
        s2(end).p = nspr(mn1,g)*pbyp0(s1(end).m,g)/pbyp0(m2,g);
        s2(end).t = 1;
        s2(end).angle = s1(end).angle + ang;
        s2(end).proc = ['deflect'];
        
    else % expansion
        
        s2(end+1).m = prandtlmeyer(s1(end).m,abs(ang),g,gldef.small);
        s2(end).p = 1;
        s2(end).t = 1;
        s2(end).angle = s1(end).angle + ang;
        s2(end).proc = 'deflect';
    end
    
       
end
    
        
        

