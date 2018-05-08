function sys = LPF(w,varargin)
% sys = LPF(w) or sys = LPF(w,zeta)
%
% low pass filter, used for increasing robustness at high freq
% w is the frequency at which the gain starts to decrease,
% and zeta is the damping ration if a second order filter is requested.

if isempty(varargin)
    sys = tf([w],[1 w]);
else
    zeta = varargin{1};
    sys = tf([w^2],[1 2*zeta*w w^2]);
end