function ff = presdef(ss,labels,colors,f)
% presdef   gaslab routine to make a pressure-deflection diagram
%
%   presdef works the same way as mollier (type "help mollier" for more
%   info).  States with subsonic Mach number will not be plotted.
%
%
%   gaslab must be initialized (help gaslab) before using this routine.
%

    global gldef
    g = gldef.g;

    if nargin < 4
         f = figure;
         if nargin < 3
             colors = gldef.color;
             if nargin < 2
                for k=1:length(ss)
                    labels{k} = num2str(k);
                end
            end
         end
    end

    
    p = pres(ss)./pres(ss,1);
    
    maxp = max(p);
    
    ff = figure(f);
    if nargin==4
        hold on;
    end

    pltfull = 0;  % flag to determine if anything has been plotted

    for k=1:length(ss)
        if ~isempty(labels{k}) && ss(k).m > 1
    
            m = ss(k).m;
            beta = linspace(asin(1/m),pi/2,100);
            theta = tbm(m,beta,g);

            pshock = p(k)*nspr( m*sin(beta), g);
            maxp = max([maxp pshock]);
            mexp = linspace(m,10*m);
            thexp = pmnu(mexp,g)-pmnu(m,g);
            pexp = p(k)*pbyp0(mexp,g)./pbyp0(m,g);

            d = ss(k).angle;       

            plt1 = plot(180*(d+theta)/pi,pshock,'Color',colors{k},'LineWidth',gldef.linewidth);
            hold on
            plt2 = plot(180*(d-theta)/pi,pshock,'Color',colors{k},'LineWidth',gldef.linewidth,'LineStyle','--');
    %     
            plt3 = plot(180*(d-thexp)/pi,pexp,'Color',colors{k},'LineWidth',gldef.linewidth);
            plt4 = plot(180*(d+thexp)/pi,pexp,'Color',colors{k},'LineWidth',gldef.linewidth,'LineStyle','--');
            pltfull = 1;
        end
    end
    for k=1:length(ss)
        if ~isempty(labels{k}) && ss(k).m > 1
            d = ss(k).angle;
            vertln = plot([180*d/pi 180*d/pi],[0 1.1*maxp],'Color',colors{k},'LineStyle','-.');
        end
    end
    for k=1:length(ss)
        if ~isempty(labels{k}) && ss(k).m > 1
            d = ss(k).angle;
            plot(180*d/pi,p(k),'Marker','o','MarkerFaceColor','w',...
                'MarkerEdgeColor',colors{k},'MarkerSize',20)
            text(180*d/pi,p(k),labels{k},'FontSize',12,...
                'HorizontalAlignment','center','VerticalAlignment','middle');
        end
    end
    
    if pltfull
        axis([-50 50 0 1.1*maxp])
    
        title('Pressure-Deflection Diagram')
        xlabel('Angle (deg)')
        ylabel('P/P_1')
        
    
        set(gca,'FontSize',gldef.fontsize)
        
    else
        warning('presdef: No supersonic states, so nothing to plot');
        if nargin < 4
            delete(ff)
        end
    end
    hold off
end

    