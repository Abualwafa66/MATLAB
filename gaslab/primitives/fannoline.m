function h = fannoline(m0,s0,t0,gam,col,linewid)

    trat = @(m) ( 1 + (gam-1)*m^2/2).^(-1);

    tstar = @(m) (gam+1).*( 2*ones(size(m))+ (gam-1)*m.^2 ).^(-1);
    pstar = @(m) (m./tstar(m).^0.5).^(-1);
    sstar = @(m) log(tstar(m).*(pstar(m)).^((1-gam)/gam));

    ma = gldef.machrange;

    x = sstar(ma)-sstar(m0)+s0;
    y = t0.*trat(m0).*tstar(ma)./tstar(m0);

    h = plot( x, y,'Color',col,'LineWidth',linewid);
    
end

