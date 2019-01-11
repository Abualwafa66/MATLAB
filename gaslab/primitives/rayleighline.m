function h = rayleighline(m0,s0,t0,gam,col,linewid)

    trat = @(m) ( 1 + (gam-1)*m^2/2).^(-1);
    % 
    tstar = @(m) m.^2 .* (( (ones(size(m)) + gam*m.^2)/(1+gam)).^(-2));
    pstar = @(m) (gam+1)*(ones(size(m))+gam*m.^2).^(-1);
    sstar = @(m) log(tstar(m).*(pstar(m)).^((1-gam)/gam));
    
    ma = gldef.machrange;

    x = sstar(ma)-sstar(m0)+s0;
    y = t0.*trat(m0).*tstar(ma)./tstar(m0);

    h = plot( x, y,'Color',col,'LineWidth',linewid,'LineStyle','--');
    
end
