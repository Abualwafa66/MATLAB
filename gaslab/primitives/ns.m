function m2 = ns(m,g)

    m2 = sqrt( ( 1 + (g-1)*m.^2/2) / (g*m.^2 - ((g-1)/2)));
    
end
