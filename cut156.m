function [t, T1, T2, T3, T4, T5, P1, P2, duty] = ...
    cut156(t, T1, T2, T3, T4, T5, P1, P2, duty, starttime)

ind = find(t == starttime,1);

T1(1:ind-1) = [];
T2(1:ind-1) = [];
T3(1:ind-1) = [];
T4(1:ind-1) = [];
T5(1:ind-1) = [];
P1(1:ind-1) = []; 
P2(1:ind-1) = []; 
duty(1:ind-1) = [];
t(1:ind-1) = []; 
t = t- t(1);


end
    