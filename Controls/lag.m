function sys = lag(w, ratio)
% sys = lag(w)
%
% Lag controller, used for increasing tracking performance at small freq
% wc is the frequency at which the gain starts to increase,
% and ratio is the ratio of zero over pole, is the amount the magnitude
% will increase.

z = w;
p = z/ratio;
sys = tf([1 z],[1 p]);

end