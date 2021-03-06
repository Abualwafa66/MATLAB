close all, clear all
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on')
set(0, 'defaultfigureposition', [380 320 540 200]);
set(0, 'defaultaxeslinewidth',  0.7);
set(0, 'defaultaxesfontsize',   7);
set(0, 'defaultlinelinewidth',  .9);
set(0, 'defaultpatchlinewidth', .9);
set(0, 'defaultlinemarkersize', 15); 
set(0, 'defaultaxesfontweight', 'normal'); 
set(0, 'defaulttextinterpreter', 'latex'); 
format compact
format short
chebfunpref.setDefaults('factory');
FS = 'fontsize'; LW = 'linewidth'; MS = 'markersize'; CO = 'color';
IN = 'interpret'; LT = 'latex';
XT = 'xtick'; YT = 'ytick';
XTL = 'xticklabel'; YTL = 'yticklabel';
LO = 'location'; NE = 'northeast'; NO = 'north';
HA = 'HorizontalAlignment'; CT = 'center'; RT = 'right';
FN = 'fontname';
purple = [.8 0 1]; green = [0 .7 0];
ivp = [0 .9 0]; ivpnl = [0 .45 0];
ivpnllight = [.4 .65 .4];
bvp = [0 0 1]; bvpnl = [0 0 .5];
ibvp = [.85 0 .8]; ibvp0 = [.5 0 .4];
orange = [1 .5 0];
ibvp = orange; ibvp0 = .6*ibvp;
