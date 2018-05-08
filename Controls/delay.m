function sys = delay(t)

sys = tf([t^2/12 -t/2 1],[t^2/12 t/2 1]);