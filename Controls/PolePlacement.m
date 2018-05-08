clear; close all; clc; figfactory;
%% Cross Over Frequency
wc = pi/0.01/10;
%% Print Pole Zeros?
print_zp = 0;
%% Print T?
print_T = 0;
%% Print LaTeX?
print_latex = 1;
%% Save Figure?
filename = 'D1';
%% Display Discrete Controller?
discrete = 1; h = 0.01;
%% Plant: Enter or Load
%num = [1 0.3]; den = [1 0 0]; G = tf(num,den);
load('G1.mat'); G = G1;
%% Time Delay
time_delay = h/2;
%% Controller
% Gain
% if unspecified will calculate the gain to obtain the correct crossover freq
K = [];

des = PolyConv([1 100],[1 0]);
des_override =[];
extra_D = 1; % Any extra controller to add after pole placement?
extra_L = 1; % Add INNER LOOP to performance analysis, but not pole placement?
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Filter Recommendation:
[G_num, G_den] = tfcoef(G);
[z_G, p_G,~] = tf2zpk(G_num, G_den);
if length(G_num) < length(G_den);
    fprintf('Recommend %d order filtering at frequencies below %f rad/s\n', ...
        -length(G_num)+length(G_den),max(abs(real(p_G))));
end
%% Calculate Controller
p_G_temp = p_G;
p_G_temp(p_G == 0) = [];
for i = 1:length(p_G_temp);
    des=PolyConv(des,[1 abs(real(p_G_temp(i)))-1i*imag(p_G_temp(i))]);
end
if ~isempty(des_override); des = des_override; end
% Diophantine
[D_den,D_num,r,s] = Diophantine(G_den,G_num,des);
D = tf(D_num, D_den)*extra_D;
%% Calculate Gain to exactly crossover at wc if Gain unspecified
if isempty(K);
    K = 1/abs(freqresp(G*D*delay(time_delay),wc));
end
%% Performance
L = minreal(K*G*D*delay(time_delay)*extra_L);
[L_num, L_den] = tfcoef(L);
T_num = L_num; T_den = PolyAdd(L_num, L_den);
T_num  = T_num./T_den(1); T_den = T_den./T_den(1);
if print_T; T = tf(T_num, T_den)
else T = tf(T_num, T_den);
end
[GM,PM,~,~] = margin(L);
tracking = freqresp(T,0);
%% Result
Result.K = K; Result.PM = PM; Result.wc = wc;
Result.G = G;
Result.Gnum = G_num; Result.Gden = G_den;
if ~time_delay
    G_delay = G*delay(time_delay);
    Result.G_delay = G_delay;
    [G_num_delay, G_den_delay] = tfcoef(G_delay);
    Result.Gnum_delay = G_num_delay; Result.Gden_delay = G_den_delay;
end
Result.D = D;
Result.Dnum = D_num; Result.Dden = D_den;
Result.T = T;
Result.Tnum = T_num; Result.Tden = T_den;
%% Pole Zeros
[~, p_des,~] = tf2zpk(1, des);
[z_D, p_D,~] = tf2zpk(D_num, D_den);
[z_T, p_T,~] = tf2zpk(T_num, T_den);
%% Step
if length(z_T) <= length(p_T);
    step_T = stepinfo(T);
    fprintf('\nSteady State Gain of %.3f\n',tracking);
    fprintf('Rise Time: %.3f sec, Settling Time: %.3f sec\n',...
        step_T.RiseTime, step_T.SettlingTime);
    fprintf('Overshoot: %.3f%%, Undershoot: %.3f%%\n\n',...
        step_T.Overshoot, step_T.Undershoot);
end
%% Print Pole Zeros
if print_zp;
    disp('Pole of Destination'); disp(p_des);
    disp('Pole of Plant'); disp(p_G); disp('Zero of Plant'); disp(z_G);
    disp('Pole of Controller'); disp(p_D); disp('Zero of Controller'); disp(z_D);
    disp('Pole of Close Loop'); disp(p_T);
end
%% DT Controller
if discrete
    discopts = c2dOptions('Method','tustin','PrewarpFrequency',wc);
    Dk = c2d(D,h,discopts)
    Result.Dk = Dk;
    [Dk_num, Dk_den] = tfcoef(Dk);
    Result.Dknum = Dk_num; Result.Dkden = Dk_den;
    disp('Dk_num');
    for i = 1:length(Dk_num); fprintf('%8.4f, ',Dk_num(i)); end
    fprintf('\b\b\n');
    disp('Dk_den');
    for i = 1:length(Dk_den); fprintf('%8.4f, ',Dk_den(i)); end
    fprintf('\b\b\n');
end
%% Print LaTeX
if print_latex;
    %disp('f(s)'); disp(str2latex(poly2str(des)));
    disp('G(s)'); disp(str2latex(tf2str(G)));
    disp('D(s)'); disp(str2latex(tf2str(D)));
    disp('L(s)'); disp(str2latex(tf2str(L)));
    if discrete
        disp('Dk(s)'); disp(str2latex(tf2str(Dk)));
    end
    disp('T(s)'); disp(str2latex(tf2str(T)));
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
ax = axis; loglog([wc,wc],[ax(3) ax(4)],'--k');
axis([ax(1) ax(2) ax(3) ax(4)]); hold off;
subplot(4,2,7); hold on;
ax = axis; loglog([wc,wc],[ax(3) ax(4)],'--k');
axis([ax(1) ax(2) ax(3) ax(4)]); hold off;
% Close Loop Bode
Bode(T,4,2,2,4);
subplot(4,2,2); title('Bode Plot of Close Loop Transfer Function');
subplot(4,2,2); hold on;
ax = axis; loglog([wc,wc],[ax(3) ax(4)],'--k');
axis([ax(1) ax(2) ax(3) ax(4)]); hold off;
subplot(4,2,4); hold on;
ax = axis; loglog([wc,wc],[ax(3) ax(4)],'--k');
axis([ax(1) ax(2) ax(3) ax(4)]); hold off;
% Step
if length(z_T) <= length(p_T);
    subplot(4,2,6); stepplot(T);
    ax=axis; hold on; plot([ax(1) ax(2)],[1 1],'--k');
    axis([ax(1) ax(2) ax(3) ax(4)]); hold off;
end
%% Display window
subplot(4,2,8); hold on;
% Lines
plot([0 0.9],[0 0],'-k'); plot([0 0.9],[1 1],'-k');
plot([0 0],[0 1],'-k'); plot([0.9 0.9],[0 1],'-k');
plot([0 0.9],[0.6 0.6],'--k'); plot([0 0.9],[0.4 0.4],'--k');
plot([0.3 0.3],[0 0.6],'--k');
% wc, K, PM, GM
str = sprintf('$\\omega_c = %.3g$ rad/s, \\quad K = %.3g, \\quad PM = %.3g deg \\quad GM = %.3f' ...
    ,wc,K,PM,GM);
% Stability
if all(real(p_T)<=0); str = ['Stable,  \quad' str];
else str = ['Unstable, \quad' str];
end
text(0.45,0.8,str,'fontsize',10,'interpreter','latex','HorizontalAlignment','center');
% Plant
text(0.15,0.5,'Plant','fontsize',10,'interpreter','latex','HorizontalAlignment','center');
%text(0.15,0.2,tf2str(G),'fontsize',15,'interpreter','latex','HorizontalAlignment','center');
% CT Dontroller
text(0.6,0.5,'CT Controller','fontsize',10,'interpreter','latex','HorizontalAlignment','center');
text(0.6,0.2,tf2str(D),'fontsize',15,'interpreter','latex','HorizontalAlignment','center');
% Graph
xlim([0 0.9]); ylim([0 1]); hold off; axis off;
%% Save Figure and Data
if ~isempty(filename);
    savefigure(1,[],[],[],[],[filename '_dioph.png']);
    save([filename '_dioph.mat'],'Result');
end
