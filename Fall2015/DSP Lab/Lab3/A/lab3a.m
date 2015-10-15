% xc(t) = cos(2?*fo*t) with fo = 20Hz 
% t=(t1:T:t2); x=cos(2*pi*f*t)

%   1)
%       a) Plot original signal xc(t)
%       b) sampled signal x[n]
%       c) reconstructed signal xr(t) 

%       a) original signal xc(t)
fo = 20;
t1 = -0.5 ; t2 = -t1;
dt = 0.001;
t = (t1:dt:t2);
xc = cos(2*pi*fo*t);
figure
subplot(3,1,1);
plot(t,xc)


%       b) sampled signal x[n]
%   Sampling at 40Hz    omega = 2pi/T
omega = 40;
T = (1)/omega; 
%t = (t1:T:t2); % sample every T secs from t1 to t2
N = omega*(abs(t1*2));
tn = (t1:T:t2);
%tn = linspace(t1,t2,N+1);
xn = cos(2*pi*fo*tn);
subplot(3,1,2);
plot(tn,xn)   
%axis([-0.05 0.05]);

t=(t1:dt:t2);
ts=(t1:T:t2);
[G1,G2]=meshgrid(t,ts);
S = sinc(omega*(G1-G2));
yr=(xn*S);
%yr = conv(xn,S);
subplot(3,1,3);
plot(yr)
%axis([-0.5 0.5 -1 1]);