function Bode(sys,varargin)
% function Bode(sys)
% The continuous-time Bode plot of G(s)=sys(s)

if isempty(varargin)
    a = 2; b = 1; c = 1; d = 2;
else
    a = varargin{1}; b = varargin{2};
    c = varargin{3}; d = varargin{4};
end

[num, den] = tfcoef(sys);
[z,p,~] = tf2zpk(num,den);
pz = [abs(z); abs(p)];
pz(pz==0) = []; pz = log10(pz);
omega = 10.^linspace(floor(min(pz))-1,ceil(max(pz))+1,1000);
arg=1i*omega;

subplot(a,b,c);
loglog(omega,abs(PolyVal(num,arg)./PolyVal(den,arg)),'b'); hold on;
ax=axis;
if ax(4) > 1 && ax(3) < 1;
    loglog([omega(1),omega(end)],[1 1],'--k');
end
xlabel('Frequency (rad/s)');
ylabel('Magnitude');
hold off;

subplot(a,b,d); 
phase_vec = phase(PolyVal(num,arg)./PolyVal(den,arg))*180/pi;
if max(phase_vec) > 180; phase_vec = phase_vec -360; end
semilogx(omega,phase_vec,'b'); hold on;
ax=axis;
if ax(4) > -180 && ax(3) < -180;
    semilogx([omega(1),omega(end)],[-180 -180],'--k');
end
xlabel('Frequency (rad/s)');
ylabel('Phase (deg)');
hold off;

end 