function out = flow_deflect(M1,delta,out_str)

if delta > 0;
    out = Shock_func('M1', M1,'delta', delta, 'super', out_str);
elseif delta < 0;
    out = PME_func('M1', M1,'theta', -delta, out_str);
end