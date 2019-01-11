function ar = arstar(m,g)
    
    fac = (1 + (g-1)*m.^2/2);
    ar = (1./m).*( (2/(g+1))*fac).^((g+1)/2/(g-1)); 
    
end