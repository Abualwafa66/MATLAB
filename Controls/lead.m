function sys = lead(wc,ratio)
% sys = lead(wc,ratio)
%
% Lead controller, used for increasing phase margin at cross over frequency
% wc is the cross over frequency, and ratio is the ratio of pole over zero
% Rule of thumb: p/z = 10, phase increase = 55 deg.

p = wc*sqrt(ratio);
z = wc/sqrt(ratio);
sys = tf([1 z],[1 p]);

end
