classdef spinpreference
%SPINPREFERENCE   Abstract class for managing preferences for SPIN, SPIN2 and 
%SPIN3.
%   SPINPREFERENCE is an abstract class for managing preferences when solving 
%   a time-dependent PDE defined by a SPINOPERATOR. SPINPREF (for SPIN in 1D), 
%   SPINPREF2 (for SPIN2 in 2D) and SPINPREF3 (for SPIN3 in 3D) are full 
%   implementations.
%
% See also SPINPREF, SPINPREF2, SPINPREF3.

% Copyright 2017 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CLASS PROPERTIES:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties ( Access = public )
        dataplot           % Which data to plot when complex values (STRING)
        dealias              % To use dealiasing with 2/3-rule (STRING)
        iterplot             % Plot every ITERPLOT iterations (1x1 INT)
        M                    % Number of points for complex means (1x1 INT)
        Nplot                % Number of points for plotting grid (1x1 INT)
        plot                 % Plot options (STRING)
        scheme               % Time-stepping scheme (STRING)
    end
   
end
