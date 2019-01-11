function tr = t0star(m,g)

    fac = ( 1 + (g-1)*m.^2/2);
    tr = 2*(g+1)*fac.*m.^2 ./ (1+g*m.^2).^2;
    
end
