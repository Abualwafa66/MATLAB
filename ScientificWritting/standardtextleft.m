function standardtextleft(x,y,str,varargin)

if isempty(varargin)
    text(x,y,str,'fontsize',15,'interpreter','latex','HorizontalAlignment','left');
elseif isfloat(varargin{1});
    text(x,y,str,'fontsize',varargin{1},'interpreter','latex','HorizontalAlignment','left');
end


end