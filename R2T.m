function T = R2T(R)

T_vec = -198:0.01:50;
R_vec = T2R(T_vec);

T = interp1(R_vec, T_vec, R);
end


