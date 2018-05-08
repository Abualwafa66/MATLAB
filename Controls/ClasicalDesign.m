clear all; close all; clc; figfactory; D = 1;
%% Cross Over Frequency
wc = 20*pi/10;
%% Save Figure?
filename = 'D1';
%% Display Discrete Controller?
discrete = 1; h = 1/20;
%% Plant: Enter or Load
% G = tf([1 0.3],[1 0 0]);
load('G2.mat'); G = G2;
%% Time Delay
time_delay = 0.0/2;
%% Controller
% +/- 1;
K1 = -1; 
% guess to stabilize the plant
D = D*tf([1],[1]); 

% Gain
% if unspecified will calculate the gain to obtain the correct crossover freq
K = [];

% Lead controller, used for increasing phase margin at cross over frequency
% wc is the cross over frequency, and ratio is the ratio of pole over zero
% Rule of thumb: p/z = 10, phase increase = 55 deg.
% wc, ratio;
lead_controller = [];

% Lag controller, used for increasing tracking performance at small freq
% wc is the frequency at which the gain starts to increase,
% and ratio is the ratio of zero over pole, is the amount the magnitude
% will increase.
% w, ratio;
lag_controller = [];

% low pass filter, used for increasing robustness at high freq
% w is the frequency at which the gain starts to decrease,
% and zeta is the damping ration if a second order filter is requested.
% w, (zeta);
first_LPF = [];
second_LPF = [];

%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Calculate Controller
if ~isempty(lead_controller);
    for i = 1:size(lead_controller,1);
        D = D *lead(lead_controller(i,1),lead_controller(i,2));
    end
end
if ~isempty(lag_controller);
    for i = 1:size(lag_controller,1);
        D = D *lag(lag_controller(i,1),lag_controller(i,2));
    end
end
if ~isempty(first_LPF);
    for i = 1:size(first_LPF,1);
        D = D *LPF(first_LPF(i,1));
    end
end
if ~isempty(second_LPF);
    for i = 1:size(second_LPF,1);
        D = D *LPF(second_LPF(i,1),second_LPF(i,2));
    end
end
%% Calculate Gain to exactly crossover at wc if Gain unspecified
if isempty(K);
    K = 1/abs(freqresp(K1*G*D*delay(time_delay),wc));
end
K = K1*K;
%% Performance
L = minreal(K*G*D*delay(time_delay));
T = minreal(L/(1+L));
[~,PM,~,~] = margin(L);
%% Result
Result.K = K; Result.PM = PM; Result.wc = wc;
Result.G = G;
[G_num, G_den] = tfdata(G,'v');
Result.Gnum = G_num; Result.Gden = G_den;
[z_G, p_G,~] = tf2zpk(G_num, G_den);
if ~time_delay
    G_delay = G*delay(time_delay);
    Result.G_delay = G_delay;
    [G_num_delay, G_den_delay] = tfdata(G_delay,'v');
    Result.Gnum_delay = G_num_delay; Result.Gden_delay = G_den_delay;
end
Result.D = D;
if isa(D,'tf');
    [D_num, D_den] = tfdata(D,'v');
    Result.Dnum = D_num; Result.Dden = D_den;
    [z_D, p_D,~] = tf2zpk(D_num, D_den);
end
Result.L = L;
[L_num, L_den] = tfcoef(L);
Result.Lnum = L_num; Result.Lden = L_den;
%% Print Screen
disp('Pole of Plant'); disp(p_G); disp('Zero of Plant'); disp(z_G);
if isa(D,'tf');
    disp('Pole of Controller'); disp(p_D); disp('Zero of Controller'); disp(z_D);
end
%% DT Controller
if discrete
    discopts = c2dOptions('Method','tustin','PrewarpFrequency',wc);
    Dk = c2d(D,h,discopts)
    Result.Dk = Dk;
    [Dk_num, Dk_den] = tfdata(Dk,'v');
    Result.Dknum = Dk_num; Result.Dkden = Dk_den;
end
%% Plot
standardfigure(1); hold on;
% Root Locus
subplot(2,2,1); h = rlocusplot(L);
p = getoptions(h);
p.Title.String = 'Root Locus of Open Loop Transfer Function';
setoptions(h,p);
% Open Loop Bode
Bode(L,4,2,5,7);
subplot(4,2,5); title('Bode Plot of Open Loop Transfer Function');
subplot(4,2,5); hold on;
ax = axis; loglog([wc,wc],[ax(3) ax(4)],'--k'); hold off;
subplot(4,2,7); hold on;
ax = axis; loglog([wc,wc],[ax(3) ax(4)],'--k'); hold off;
% Close Loop Bode
Bode(T,4,2,2,4);
subplot(4,2,2); title('Bode Plot of Close Loop Transfer Function');
% Step
subplot(4,2,6); stepplot(T);
ax=axis; hold on; plot([ax(1) ax(2)],[1 1],'--k'); hold off;
%% Display window
subplot(4,2,8); hold on;
% Lines
plot([0 0.9],[0 0],'-k'); plot([0 0.9],[1 1],'-k');
plot([0 0],[0 1],'-k'); plot([0.9 0.9],[0 1],'-k');
plot([0 0.9],[0.6 0.6],'--k'); plot([0 0.9],[0.4 0.4],'--k');
plot([0.3 0.3],[0 0.6],'--k');
% wc, K, PM
str = sprintf('$\\omega_c = %.3g$ rad/s, \\quad K = %.3g, \\quad PM = %.3g deg',wc,K,PM);
% Stability
[num_T, den_T] = tfdata(T,'v');
[~, pole, ~] = tf2zpk(num_T, den_T);
if all(real(pole)<=0); str = ['Stable,  \quad' str];
else str = ['Unstable, \quad' str];
end
text(0.45,0.8,str,'fontsize',15,'interpreter','latex','HorizontalAlignment','center');
% Plant
text(0.15,0.5,'Plant','fontsize',10,'interpreter','latex','HorizontalAlignment','center');
text(0.15,0.2,tf2str(G),'fontsize',15,'interpreter','latex','HorizontalAlignment','center');
% CT Dontroller
text(0.6,0.5,'CT Controller','fontsize',10,'interpreter','latex','HorizontalAlignment','center');
text(0.6,0.2,tf2str(D),'fontsize',15,'interpreter','latex','HorizontalAlignment','center');
% Graph
xlim([0 0.9]); ylim([0 1]); hold off; axis off;
%% Save Figure and Data
if ~isempty(filename);
    savefigure(1,[],[],[],[],[filename '_classical.png']);
    save([filename '_classical.mat'],'Result');
end
