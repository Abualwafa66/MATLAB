function status = odeprog(t,y,flag,varargin)
%   status = odebarplot(t,y,flag,varargin)
%   ODE progress display function with interrupt control
%   Displays a vertical bar plot that fills as the simulation
%   nears its completion.  Also displays time ellapsed and estimates
%   time remaining in the simulation.

global odeprogglobvar

if nargin < 3 || isempty(flag)
    if(etime(clock,odeprogglobvar(8:13))>=30)
        tfin     = odeprogglobvar(1);
        sstrt    = odeprogglobvar(2:7);
        old_time = odeprogglobvar(8:13);
        old_perc = odeprogglobvar(14);
        current_time = clock;
        figure(95); perc = t(end)/tfin;
        area([t(end) tfin-t(end); t(end) tfin-t(end)]);
        
        set(findobj('Tag','percent'),'String',sprintf('%9.6f%%',perc*100));
        set(findobj('Tag','eltime' ),'String',etimev(current_time,sstrt));
        set(findobj('Tag','esttime'),'String',etimev(etime(current_time,old_time)/(perc-old_perc)*(1-perc)));
        
        odeprogglobvar(8:13) = current_time;
        odeprogglobvar(14)   = perc;
        drawnow;
    end
else
    switch(flag)
        case 'init'
            odeprogglobvar       = zeros(1,14);
            odeprogglobvar(1)    = t(end);
            odeprogglobvar(2:7)  = clock;
            odeprogglobvar(8:13) = clock;
            tfin  = odeprogglobvar(1);
            figure(95); set(gcf,'Position',[4,40,160,600]); axes('Position',[0.3,0.2,0.4,0.65]);
            axis([1,2,0,tfin]); set(gca,'XTickLabel',[],'NextPlot','replacechildren');
            area([0 tfin;0 tfin]);
            uicontrol('Style', 'text', 'String', 'Progress','fontsize',12                ,'Position', [25 560 110 25]);
            uicontrol('Style', 'text', 'Tag'   , 'percent' , 'String', '0%','fontsize',12,'Position', [25 530 110 25]);
            uicontrol('Style', 'text', 'String', 'Ellapsed Time'                         ,'Position', [35  80  90 15]);
            uicontrol('Style', 'text', 'Tag'   , 'eltime'  , 'String', 'NaN'             ,'Position', [35  60  90 15]);
            uicontrol('Style', 'text', 'String', 'Time Remaining'                        ,'Position', [35  40  90 15]);
            uicontrol('Style', 'text', 'Tag'   , 'esttime' , 'String', 'Inf'             ,'Position', [35  20  90 15]);
            drawnow;
            
        case 'done'
            if(ishandle(95)); close(95); end
    end
end
status = 0;
end



function [S] = etimev(t1,t0)

if(exist('t1') & exist('t0') & length(t1)>2 & length(t0)>2)
    t=etime(t1,t0); if(t<0); t=-t; end
elseif(length(t1)==1)
    t=t1;
else
    t=0;
end

days=floor(t/(24*60*60)); t=t-days*24*60*60;
hours=floor(t/(60*60));   t=t-hours*60*60;
mins=floor(t/60);         t=floor(t-mins*60);

if(days>0)
    S=[num2str(days) 'd ' num2str(hours) 'h ' num2str(mins) 'm'];
elseif(hours>0)
    S=[num2str(hours) 'h ' num2str(mins) 'm ' num2str(t) 's'];
elseif(mins>0)
    S=[num2str(mins) 'm ' num2str(t) 's'];
else
    S=[num2str(t) 's'];
end
end