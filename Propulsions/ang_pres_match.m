function d_ang_1 = ang_pres_match(M1_up, M2_up, rel_ang, P2div1)

f = @(delta) flow_deflect(M1_up,delta,'P')/flow_deflect(M2_up,rel_ang-delta,'P') - P2div1;

max_delta1 = Shock_func('M1', M1_up, 'M2', 1, 'super','delta');
max_delta2 = Shock_func('M1', M2_up, 'M2', 1, 'super','delta');

eps = 0.001;

if P2div1 < 1;
    d_ang_1 = fzero(f,[rel_ang-max_delta2+eps, min(rel_ang,max_delta1)-eps ]);
elseif P2div1 > 1;
    d_ang_1 = fzero(f,[max(0,rel_ang-max_delta2)+eps, max_delta1-eps]);
end
