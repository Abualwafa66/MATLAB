clear; close all; clc; figfactory;
%% Print Pole Zeros?
print_zp = 0;
%% Print LaTeX?
print_latex = 0;
%% Plot?
plotornot = 1;
savefig = 1;
filename = 'D1';
%% Plant: Enter or Load
cd('..\'); run parameters; cd('.\ControllerDesign');

b2 = m2; b1 = d2; b0 = k2;
a4 = m1*m2; a3 = (m1*d2 + m2*d1); a2 = (k2*m1 + (k1 + k2)*m2 + d1*d2);
a1 = ((k1 + k2)*d2 + k2*d1); a0 = k1*k2;

G_num = 9.7656e-3.*[b2 b1 b0]; G_den = conv([a4 a3 a2 a1 a0],[1/209 1]);
G = tf(G_num,G_den);

%% PID Controller (controller zero roughly 1/Ti, 1/Td)
K = 0.05;
Ti = 0.09;
Td = 0.14;

kp = K;
kd = kp*Td; %kd = 0;
ki = kp/Ti; %ki = 0;
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% ------------------------------------------------------------------------
%% Calculate Controller
D_num = [kd kp ki];
D_den = [1 0];
D =  minreal(tf(D_num, D_den));
%% Performance
L = minreal(G*D);
[L_num, L_den] = tfcoef(L);
T_num = L_num; T_den = PolyAdd(L_num, L_den);
T_num  = T_num./T_den(1); T_den = T_den./T_den(1);
T = tf(T_num, T_den);
[GM,PM,~,~] = margin(L);
tracking = freqresp(T,0);
%% Result
Result.PID = [kp, ki, kd];
Result.PM = PM;
Result.GM = GM;
Result.G = G;
Result.Gnum = G_num; Result.Gden = G_den;
Result.D = D;
Result.Dnum = D_num; Result.Dden = D_den;
Result.T = T;
Result.Tnum = T_num; Result.Tden = T_den;
%% Pole Zeros
[z_G, p_G,~] = tf2zpk(G_num, G_den);
[z_D, p_D,~] = tf2zpk(D_num, D_den);
[z_T, p_T,~] = tf2zpk(T_num, T_den);
%% Step
if length(z_T) <= length(p_T);
    step_T = stepinfo(T);
    if all(real(p_T)<=0); disp('Stable!!!!');
    else disp('Unstable'); end
    fprintf('\nKp = %.5f; Ki = %.5f; Kd = %.5f\n',kp, ki, kd);
    fprintf('\nSteady State Gain of %.3f\n',tracking);
    fprintf('Rise Time: %.3f sec, Settling Time: %.3f sec\n',...
        step_T.RiseTime, step_T.SettlingTime);
    fprintf('Overshoot: %.3f%%, Undershoot: %.3f%%\n',...
        step_T.Overshoot, step_T.Undershoot);
    fprintf('PM: %.1f deg, GM: %.3f\n\n',PM, GM);
end
%% Print Pole Zeros
if print_zp;
    disp('Pole of Plant'); disp(p_G); disp('Zero of Plant'); disp(z_G);
    disp('Pole of Controller'); disp(p_D); disp('Zero of Controller'); disp(z_D);
    disp('Pole of Close Loop'); disp(p_T);
end
%% Print LaTeX
if print_latex;
    disp('G(s)'); disp(str2latex(tf2str(G)));
    disp('D(s)'); disp(str2latex(tf2str(D)));
    disp('L(s)'); disp(str2latex(tf2str(L)));
    disp('T(s)'); disp(str2latex(tf2str(T)));
end
%% Plot
if plotornot;
    %% Plant Plots
    standardfigure(1); hold on;
    % Root Locus
    subplot(2,2,1); h = rlocusplot(G);
    p = getoptions(h);
    p.Title.String = 'Root Locus of G(s)';
    setoptions(h,p); axis([-5 5 -100 100]);
    % Open Loop Bode
    Bode(G,4,2,5,7);
    subplot(4,2,5); title('Bode Plot of Plant G(s)');
    
    % Display window
    subplot(2,2,2); hold on;
    % Lines
    xend = 0.9; yend = 0.9;
    plot([0 xend],[0 0],'-k'); plot([0 xend],[yend yend],'-k');
    plot([0 0],[0 yend],'-k'); plot([xend xend],[0 yend],'-k');
    plot([0 xend],[yend/3 yend/3],'--k');
    plot([0 xend],[2*yend/3 2*yend/3],'--k');
    % Plant
    standardtext(xend/2,0.8,'Plant');
    standardtext(xend/2,0.7,tf2str(minreal(G)));
    standardtext(xend/2,0.5,'Poles');
    standardtext(xend/2,0.4,complex2latex(p_G,2),12);
    standardtext(xend/2,0.2,'Zeros');
    standardtext(xend/2,0.1,complex2latex(z_G,2),12);
    % Graph
    xlim([0 xend]); ylim([0 yend]); hold off; axis off;

    %% Close Loop Plots
    standardfigure(2); hold on;
    % Root Locus
    subplot(2,2,1); h = rlocusplot(L);
    p = getoptions(h);
    p.Title.String = 'Root Locus of Open Loop Transfer Function L(s)';
    setoptions(h,p);
    % Open Loop Bode
    Bode(L,4,2,5,7);
    subplot(4,2,5); title('Bode Plot of Open Loop Transfer Function L(s)');
    % Close Loop Bode
    Bode(T,4,2,2,4);
    subplot(4,2,2); title('Bode Plot of Close Loop Transfer Function T(s)');
    % Step
    if length(z_T) <= length(p_T);
        subplot(4,2,6); stepplot(T);
        ax=axis; hold on; plot([ax(1) ax(2)],[1 1],'--k');
        axis([ax(1) ax(2) ax(3) ax(4)]); hold off;
    end
    % Display window
    subplot(4,2,8); hold on;
    % Lines
    xend = 0.9; yend = 1;
    plot([0 xend],[0 0],'-k'); plot([0 xend],[yend yend],'-k');
    plot([0 0],[0 yend],'-k'); plot([xend xend],[0 yend],'-k');
    plot([0.6 xend],[0.5 0.5],'--k'); plot([0.6 xend],[0.3 0.3],'--k');
    plot([0.6 0.6],[0 yend],'--k');
    % PM, GM
    str = sprintf('PM = %.3g deg \\quad GM = %.3f \nSteady State Gain: %.3f\n$t_r = %.3f$ sec,\\quad $t_s = %.3f$ sec\nOvershoot: %.3f\\%%, Undershoot: %.3f\\%%' ...
        ,PM,GM,tracking,step_T.RiseTime, step_T.SettlingTime, step_T.Overshoot, step_T.Undershoot);
    % Stability
    if all(real(p_T)<=0); str = [sprintf('Stable \n') str];
    else str = [sprintf('Unstable \n') str];
    end
    standardtext(0.3,yend/2,str,12);
    % CT Dontroller
    standardtext(0.75,0.75,sprintf('$k_p = %.3f$\n$k_i = %.3f$\n$k_d = %.3f$',kp,ki,kd),12);
    standardtext(0.75,0.4,'PID Controller');
    standardtext(0.75,0.15,tf2str(D));
    % Graph
    xlim([0 xend]); ylim([0 yend]); hold off; axis off;
end
%% Save Figure and Data
if plotornot && savefig;
    savefigure(1,[],[],[],[],[filename '_sys.png']);
    savefigure(2,[],[],[],[],[filename '_PID.png']);
    close all;
end
save([filename '_PID.mat'],'Result');
% cd('..\');
