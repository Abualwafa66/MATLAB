function f = fstar(m,g)

    fac = ( 1 + (g-1)*m.^2/2);
    f = (1-m.^2)./ (g*m.^2) + ((g+1)/(2*g))*log( ((g+1)/2)*m.^2 ./ fac);
    
end
