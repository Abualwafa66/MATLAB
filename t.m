function t_score = t(M, dM, T, dT)

t_score = abs(M-T)/sqrt(dM^2+dT^2);