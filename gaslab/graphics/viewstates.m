function ff = viewstates(ss,labels)
% viewstates   make a table showing various quantities
%
%   ff = viewstates(ss) creates a table (in a new figure window, returned as
%   ff, showing various quantities for each state in ss.
%
%   ff = viewstates(ss,labels) uses the cell array of strings labels to
%   label each state in the table.  Empty cells in lables will not be
%   shown.
%
%   gaslab must be initialized (help gaslab) before using this routine.
%
   global gldef
   gam = gldef.g;
    
    
   if nargin < 2
      for k=1:length(ss)
           labels{k} = num2str(k);
      end
   end
    
   m = mach(ss);
   t = temp(ss);
   t0 = stagtemp(ss);
   p = pres(ss);
   p0 = stagpres(ss);
   r = density(ss);
   u = speed(ss);
   
   dat = [m',t',t0',p',p0',r',u'];
   
   rows = ~cellfun(@isempty,labels)';
   dat = dat(rows,:);
   lab = {labels{rows}};
   proc = {ss(rows).proc}';
   cdat = num2cell(dat);
   cdat = [proc, cdat];  
  
   wid = 610;
   hgt = 350;
   ff = figure;
   curpos = ff.Position;
   ff.Position = [curpos(1) curpos(2) wid hgt ];
   tbl = uitable;
   tbl.FontSize = 16;  
   tbl.Data = cdat;
   tbl.ColumnWidth = {125,125,125,125,125,125,125,125};
   if isempty(gldef.resv)
       tbl.ColumnName = {mhtml('Process'),mhtml('M'),mhtml('T / T <sub>01</sub>'),mhtml('T <sub>0</sub> / T <sub>01</sub>'),...
           mhtml('p / p <sub>01</sub>'),mhtml('p<sub>0</sub> / p <sub>01</sub>'),mhtml('&rho / &rho <sub>01</sub> '),...
           mhtml('u / a <sub>01</sub>')};
   else
      tbl.ColumnName = {mhtml('Process'),mhtml('M'),mhtml('T (K)'),mhtml('T <sub>0</sub> (K)'),...
           mhtml('p (atm)'),mhtml('p<sub>0</sub> (atm)'),mhtml('&rho (kg/m<sup>3</sup>)'),...
           mhtml('u (m/s)')};
   end
   tbl.RowName = lab;
   tt = tbl.Extent;
   tbl.Position = [10 10 tt(3) tt(4)];
   ff.Position = [curpos(1) curpos(2) tt(3)+20 tt(4)+20 ];
%   tbl.ButtonDownFcn = @modtab;   
   tbl.ColumnEditable = [false,false,false,false,false,false];
%   tbl.Enable = 'inactive';
%    leftmarg = tt(3)-125*7;
%    cmenu = uicontextmenu;
%    cmenu.Callback = @modtab;
%    tbl.UIContextMenu = cmenu;
%    
%     function modtab(src,evt)
% 
%         pt = ff.CurrentPoint - [10 10] - [leftmarg 0];
%         col = ceil(pt(1)/125);
%         chil = cmenu.Children;
%         delete(chil);
%         
%         if pt > 0
%             
%             disp('select column')
%             m1 = uimenu(cmenu,'Label',mhtml('M'),'Callback',@selectfun);
%             m2 = uimenu(cmenu,'Label',mhtml('T'),'Callback',@selectfun);
%             m3 = uimenu(cmenu,'Label',mhtml('T <sub>0</sub>'),'Callback',@selectfun);
%             m4 = uimenu(cmenu,'Label',mhtml('p'),'Callback',@selectfun);
%             m5 = uimenu(cmenu,'Label',mhtml('p <sub>0</sub>'),'Callback',@selectfun);
%             m6 = uimenu(cmenu,'Label',mhtml('&rho'),'Callback',@selectfun);
%             m7 = uimenu(cmenu,'Label',mhtml('&u'),'Callback',@selectfun);
%             m8 = uimenu(cmenu,'Label',mhtml('A/A<sup>*</sup>'),'Callback',@selectfun);
%             m9 = uimenu(cmenu,'Label',mhtml('f<sup>*</sup>'),'Callback',@selectfun);
%             m10 = uimenu(cmenu,'Label',mhtml('s-s<sub>0</sub>'),'Callback',@selectfun);  
%      
%         end
%     end
%   
    function mtag = mhtml(tag)
        
        mtag = ['<html><center /><font size=4>' tag '</font></html>'];
        
    end
      
end
