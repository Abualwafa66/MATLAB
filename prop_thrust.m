function [F, down_stream_v] = prop_thrust(diameter, pitch, RPM, cruise_v)


down_stream_v = RPM*0.0254*pitch/60;

F = 1.225*pi*(0.0254*diameter)^2/4*(down_stream_v^2-down_stream_v*cruise_v)*(diameter/3.29546/pitch)^1.5;