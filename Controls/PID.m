function [kp, ki_out, kd] = PID(sys,varargin)

%% Kp
if isempty(varargin)
    kp = 0.5*margin(sys);
elseif isfloat(varargin{1}) && varargin{1} > 0 && varargin{1} < 0.9;
    kp = varargin{1}*margin(sys);
else disp('Invalid Second Input'); kp = 0; ki_out = 0; kd = 0; return;
end

%% Kd (max phase margin)
L = minreal(sys *tf([kp], [1]));
[~,new,~,~] = margin(L);
kd = 0.0001;
old = 0;

while new > old
    old = new;
    L = minreal(sys *tf([kd kp 0], [1 0]));
    [~,new,~,~] = margin(L);
    kd = kd + 0.0001;
end
kd = kd - 0.0001;

ki = [0.01:0.01:1];
tr   = zeros(1,length(ki)); ts = zeros(1,length(ki));
over = zeros(1,length(ki));  under = zeros(1,length(ki)); 
PM = zeros(1,length(ki)); GM = zeros(1,length(ki));
tracking = zeros(1,length(ki));

%% Ki
for i = 1:length(ki);
    L = minreal(sys*tf([kd kp ki(i)], [1 0]));
    [L_num, L_den] = tfcoef(L);
    T_num = L_num; T_den = PolyAdd(L_num, L_den);
    T_num  = T_num./T_den(1); T_den = T_den./T_den(1);
    T = tf(T_num, T_den);
    [GM(i),PM(i),~,~] = margin(L);
    tracking(i) = freqresp(T,0);
    step_T = stepinfo(T);
    tr(i) = step_T.RiseTime;
    ts(i) = step_T.SettlingTime;
    over(i) = step_T.Overshoot;
    under(i) = step_T.Undershoot;
    if PM(i) <= 0;
        ki(i:end) = []; tr(i:end) = [];
        ts(i:end) = []; 
        over(i:end) = []; under(i:end) = [];
        PM(i:end) = []; GM(i:end) = [];tracking(i:end) = [];
        break;
    end
end

[~, ind] = max(PM);
ki_out = ki(ind);

standardfigure(1); clf;
subplot(3,2,1); hold on;
plot(ki,tr,'linewidth',2);
xlabel('$K_I$','interpreter','latex','fontsize',25);
ylabel('$t_r$ (sec)','interpreter','latex','fontsize',25);

subplot(3,2,2); hold on;
plot(ki,ts,'linewidth',2);
xlabel('$K_I$','interpreter','latex','fontsize',25);
ylabel('$t_s$ (sec)','interpreter','latex','fontsize',25);

subplot(3,2,3); hold on;
plot(ki,PM,'linewidth',2);
xlabel('$K_I$','interpreter','latex','fontsize',25);
ylabel('PM','interpreter','latex','fontsize',25);

subplot(3,2,4); hold on;
plot(ki,tracking,'linewidth',2);
xlabel('$K_I$','interpreter','latex','fontsize',25);
ylabel('Tracking','interpreter','latex','fontsize',25);

subplot(3,2,5); hold on;
plot(ki,tr,'linewidth',2);
xlabel('$K_I$','interpreter','latex','fontsize',25);
ylabel('OverShoot (\%)','interpreter','latex','fontsize',25);

subplot(3,2,6); hold on;
xend = 1; yend = 1;
plot([0 xend],[0 0],'-k'); plot([0 xend],[yend yend],'-k');
plot([0 0],[0 yend],'-k'); plot([xend xend],[0 yend],'-k');
plot([0 xend],[0.6 0.6],'--k');
standardtext(0.5,0.8,sprintf('$k_p = %.3f$ \\quad $k_i = %.3f$ \\quad $k_d = %.3f$',kp,ki(ind),kd),18);
standardtext(0.5,0.3,sprintf('PM = %.3g deg \\quad GM = %.3f \nSteady State Gain: %.3f\n$t_r = %.3f$ sec,\\quad $t_s = %.3f$ sec\nOvershoot: %.3f\\%%, Undershoot: %.3f\\%%' ...
    ,PM(ind),GM(ind),tracking(ind),tr(ind), ts(ind), over(ind),under(ind)));


end
