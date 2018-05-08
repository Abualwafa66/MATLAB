function savefigure(a,t,x,y,l,filename,varargin)
% savefigure(a,t,x,y,l,filename,'halfpage');
% This function saves a figure in png format for LaTeX using 10 pt font
% size.
%
% a is the figure number. This is required.
%
% t, x, y are strings for title, xlabel and ylabel, LaTeX interpreter is
% used, and can be entered as empty matrix if not needed.
%
% l is a cell containing multiple strings for the legend, LaTeX interpreter
% is used and can be entered as empty matrix if not needed.
%
% filename is '... .png' for the filename wished to use. This is required.
%
% The default is to save as full page wide figures, a string 'halfpage' can
% be entered as the last variable if needed to save as half page wide
% figures.

figure(a);
%% Title, x y label
if ~isempty(t);  title(t,'interpreter','latex','fontsize',25); end
if ~isempty(x); xlabel(x,'interpreter','latex','fontsize',25); end
if ~isempty(y); ylabel(y,'interpreter','latex','fontsize',25); end
%% Legend
if ~isempty(l)
    if ~isstruct(l);
        legend1 = legend(l);
    else legend1 = legend(l.handle, l.str);
    end
    set(legend1,'interpreter','latex'); set(legend1,'fontsize',18);
end
%% Figure size
if isempty(varargin)
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
    print(filename,'-dpng','-r240'); % for full page wide figure
elseif strcmp(varargin{1},'halfpage');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 9 8]);
    print(filename,'-dpng','-r240'); % for half page wide figure
end

end % end savefigure