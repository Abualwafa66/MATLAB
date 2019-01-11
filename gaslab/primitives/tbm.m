function th = tbm(m,b,g)

    th = atan(2*cot(b).*( m.^2 .* sin(b).^2 - 1 ) ./ (m.^2 .*(g+cos(2*b))+2));
    
end