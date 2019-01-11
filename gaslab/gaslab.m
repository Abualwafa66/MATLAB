function def = gaslab(g,p0,t0,mw)
% gaslab   Gasdynamic functions for Matlab.
%
%   def = gaslab(g) initilizes the routines for a perfect gas with ratio of
%   specific heats g.  When initialized in this way, the routines will
%   return results in nondimensional form relative to an initial stagnation
%   pressure and temperature.
%
%   def = gaslab(g,p0,t0,mw)  initilizes the routines for a perfect gas 
%   with ratio of specific heats g and molecular weight mw (g/mol), that is 
%   initially at a stagnation pressure p0 (in atm) and stagnation 
%   temperature t0 (in K). When initialized in this way, the routines will
%   return results in dimensional form
%
%   summary of units used
%
%   Quantity              Dimensionless form          Dimensional form
%
%   pressure              P / P_01                    atm
%   temperature           T / T_01                    K
%   stag. pressure        P_0 / P_01                  atm
%   stag. temperature     T_0 / T_01                  K
%   density               rho / (rho_01)         kg/m^3
%   speed                 u / a_01                    m / s
%   sound speed           a / a_01                    m / s
%
%   in the above list "0" refers to stagnation value,  "1" refers to 
%   the first state in the state list, P is pressure, T is temperature, 
%   rho is density, u is speed and a is sound speed.
%   
%   gaslab works with several kinds of objects: states, functions, and
%   processes.  states are defined internally and take the form of an array
%   (list) of structures, each element of which represents a state of the
%   system that has either been initialized or has been reached through a
%   process from another state.  
%
%   The components of the structure for each
%   state are gaslab's internal representation of the full state of the
%   fluid *relative* to the previous state on the list, or, in the case of 
%   the first state, to itself.   It is not necessary for the user to
%   understand the structure of the state variable.
%
%   Processes define new states based on previous ones.  There are
%   currently 6 defined processes.  Each process appends a state to the
%   array of states based on the kind of process, and, depending on the
%   process, some variables that determine an amount of the process.  For
%   example, isentropic, quasi-one-dimensional flow through nozzles takes
%   an argument that is the ratio of the area of the new state to the old
%   state, and an optional argument that tells the process whether there
%   was a throat, or area minimum in between.  Some processes are only
%   defined when certain conditions of the old state are true, for example
%   a normalshock process is only possible when the old state is
%   supersonic.  If conditions are not met, a new state will not be
%   appended when the process is invoked.
%
%   Finally, functions query the given array of states, and return
%   pertinent information regarding the state.  The form of the output
%   (dimensional or non-dimensional) is determined by the manner in which
%   gaslab is initialized, as discussed agove.  For specific information 
%   see the help for the individual functions
%
%   Specific help is available for each of the defined processes and functions.
%
%   There are also routines supplied that will construct Mollier (graphics/mollier) and
%   pressure-deflection (graphics/presdef) diagrams for the given state array.
%
    global gldef
    
    % default quantities
    def.small = 1e-8;
    def.machrange = 0.01:0.01:10;
    def.linewidth = 2;
    def.color = repmat({'r','g','b','c','m','y'},1,2048);  % not anticipating more than 6*2048 states
    def.fontsize = 18;
    
    % path
    p = mfilename('fullpath');
    [myfolder,~,~] = fileparts(p);
    addpath(genpath(myfolder));
    
    % process optional arguments to set stagnation properties and gas
    if nargin==1 || nargin==4
       if g < 1 || g > 2
            error('oblique: gamma must be between 1 and 2');
       else
            def.g = g;
            def.resv = [];
       end
    else
       error('gaslab: you must supply either 1 or 4 arguments');
    end
    
    if nargin == 4
        if p0 < 0 || ~isreal(p0)
            error('gaslab: stagnation pressure must be real and > 0')
        end
        if t0 < 0 || ~isreal(t0)
            error('gaslab: stagnation temperature must be real and > 0')
        end
        if t0 < 1 || ~isreal(t0)
            error('gaslab: molecular weight must be real and >= 0')
        end 
        def.resv.p0 = p0;
        def.resv.t0 = t0;
        def.resv.gcon = 8314./mw;
    end
    
    gldef = def;
    
end

    