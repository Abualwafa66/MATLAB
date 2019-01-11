function ff = mollier(ss,labels,colors,f)
% mollier   gaslab routine to make a Mollier (T-S) diagram
%
%   ff = mollier(ss) creates a Mollier diagram for each of the states in
%   ss.  ff is a handle to the resulting figure.  States are labeled
%   according to their index in ss.
%
%   ff = mollier(ss,labels) uses the cell array "labels" to label the
%   states.  labels must be a cell array of same length as ss with each
%   cell entry a character array, e.g. labels={'a','b','c'}.  If you leave
%   a cell empty, the diagram will not be drawn for that state, so that
%   labels = {'1',[],'2'} will only draw the Mollier diagram for ss(1) and ss(3)
%   and label them as "1" and "2".
%
%   ff = mollier(ss,labels,colors) will use the cell array with color
%   specifications for each state specified in labels.  so with labels =
%   {'1',[],'2'} and colors = {'r','g','b'}, the Mollier diagram will be
%   shown in red for ss(1) and blue for ss(3), and ss(2) will not be shown.
%
%   ff = mollier(ss,labels,colors,f) will overlay the Mollier diagram on
%   the figure with handle f.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
    global gldef
    gam = gldef.g;
    linewid = gldef.linewidth;
    
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
    
    t = temp(ss);
    t0 = stagtemp(ss);
    ent = entropy(ss);
    
    ff = figure(f);
    if nargin==4
        hold on;
    end
    
    xmax = max(0.5,1.25*max(ent));
    xmin = -xmax;
    ymax = 1.1*max(t0);
    ymin = 0;
    axlim = [xmin xmax ymin ymax];
    
    for k=1:length(ss)
        if ~isempty(labels{k})
            fannoline(ss(k).m,ent(k),t0(k),gam,colors{k},linewid);
            hold on
            rayleighline(ss(k).m,ent(k),t0(k),gam,colors{k},linewid);   
        end
    end
    for k=1:length(ss)
        if ~isempty(labels{k})
            plot(ent(k),t(k),'Marker','o','MarkerFaceColor','w',...
                'MarkerEdgeColor',colors{k},'MarkerSize',20)
            text(ent(k),t(k),labels{k},'FontSize',12,...
                'HorizontalAlignment','center','VerticalAlignment','middle');
        end

    end
    
    grid on
    
    axis(axlim)
    
    title('Mollier Diagram')
    xlabel('(s-s_1)/c_p')
    if isempty(gldef.resv)
        ylabel('T/T_{01}')
    else
        ylabel('T (K)')
    end
    
    set(gca,'FontSize',gldef.fontsize)
    hold off
end