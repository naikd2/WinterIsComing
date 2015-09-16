% % program for generation of exponential signal x=Ba^(n)
% n = 0:40;
% B=0.2;
% a = input('Enter the value of a');
% x = B*a.^(n)
% % ploting the exponential sequence;
% stem(n,x);
% ylabel('Amplitude')
% xlabel('Time index n');
% title('Exponential Sequence');

% % program for generation of unit sample
% % generate the discrete instants of time
% n = -10:1:15;
% % generate the unit sample sequence
% y = [zeros(1,15),ones(1,1),zeros(1,10)]
% % ploting the unit sample sequence
% stem(n,y);
% ylabel('Amplitude');
% xlabel('Time index n');
% title('Unit Impulse Sequence');
% axis([-10 10 -0.5 1.5])

% % program for generation of unit sample
% % generate the discrete instants of time
% n = -10:1:10;
% % generate the unit sample sequence
% y = [zeros(1,10),ones(1,11)]
% % ploting the unit sample sequence
% stem(n,y);
% ylabel('Amplitude');
% xlabel('Time index n');
% title('Unit Impulse Sequence');
% axis([-10 10 -0.5 1.5])


% % program for generation of unit sample
% % generate the discrete instants of time
% n = -10:1:15;
% % generate the unit sample sequence
% y = [zeros(1,15),ones(1,11)]
% % ploting the unit sample sequence
% stem(n,y);
% ylabel('Amplitude');
% xlabel('Time index n');
% title('Unit Impulse Sequence');
% axis([-10 10 -0.5 1.5])

% syms n
% % program for generation of exponential signal x=Ba^(n)
% % n = 0:40;
% B=0.2;
% %a = input('Enter the value of a');
% a = 1; % change to 0.9 and 1.2 
% x = B*a.^(n);
% % ploting the exponential sequence
% % stem(n,x);
% % ylabel(?Amplitude?);
% % xlabel(?Time index n?);
% % title(?Exponential Sequence?);
% E = symsum((abs(x)).^2, 0 , 40)
% P = E * limit(1/(2*n+1),n,40) 

n=0:40;
R=41;
B=0.2;
a=0.9;
x = B*a.^(n);
d = 0.25 * rand(1,R)- 0.125;


for ( ) 
    



