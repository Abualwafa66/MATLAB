function standardfigure(a,varargin)
% standardfigure(a,'halfpage')
% This function opens a standard figure with size suitable for saving for
% LaTeX processing. 
%
% a is the figure number you wish to create. This is required.
%
% The default is to save as full page wide figures, a string 'halfpage' can
% be entered as the last variable if needed to save as half page wide
% figures.

figure(a);
if isempty(varargin)
    set(a,'Position',[0 0 1920 1080]);
elseif strcmp(varargin{1},'halfpage');
    set(a,'Position',[0 0 900 800]);
end
end % end standardfigure