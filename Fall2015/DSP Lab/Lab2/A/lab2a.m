% % PDF Examples
%
% % Program for evaluating the DTFT of an exponential sequence
% %
% % Generate the exponential sequence
% n=-5:10;
% a=0.5;
% u=[ones(1,16)];
% x=a.^n.*u;
% % Ploting the exponential sequence
% figure(1);
% stem(n,x);
% ylabel('Amplitude');
% xlabel('Time index n');
% title('Exponential Sequence');
% %
% %Computing the DTFT of the exponential sequence using "freqz"
% w=linspace(-3*pi,3*pi,256);
% h = freqz([x], 1, w);
% %Plotting the frequency response
% figure(2);
% subplot(2,2,1)
% plot(w/pi,real(h));grid
% title('Real part')
% 
% xlabel('\omega/\pi'); ylabel('Amplitude');
% subplot(2,2,2)
% plot(w/pi,imag(h));grid
% title('Imaginary part');
% xlabel('\omega/\pi'); ylabel('Amplitude');
% subplot(2,2,3)
% plot(w/pi,abs(h));grid
% title('Magnitude Spectrum')
% xlabel('\omega/\pi'); ylabel('Magnitude');
% subplot(2,2,4)
% plot(w/pi,angle(h));grid
% title('Phase Spectrum')
% xlabel('\omega/\pi'); ylabel('Phase, radians');
% %
% %Computing the DTFT of the exponential sequence accounting for noncausality
% g = exp(-j*w*n(1)).*h;
% %Plotting the frequency response
% figure(3);
% subplot(2,2,1)
% plot(w/pi,real(g));grid
% title('Real part');
% xlabel('\omega/\pi'); ylabel('Amplitude');
% subplot(2,2,2)
% plot(w/pi,imag(g));grid
% title('Imaginary part');
% xlabel('\omega/\pi'); ylabel('Amplitude');
% subplot(2,2,3)
% plot(w/pi,abs(g));grid
% title('Magnitude Spectrum');
% xlabel('\omega/\pi?); ylabel(?Magnitude');
% subplot(2,2,4)
% plot(w/pi,angle(g));grid
% title('Phase Spectrum');
% xlabel('\omega/\pi'); ylabel('Phase, radians');


clear; 

%input values for ccrs
x = [1 2 3 2 1];
y = [2 1 0 -1 -2];
%bounds of x
nx = [-2 2];
%bounds of y
ny = [-2 2];

ccrs(x,y,nx,ny)

% x5 = ones(1, 5);
% w=linspace(-3*pi,3*pi,256);
% figure(2);
% plot(freqz(x5,1,w)); grid

%Actual Answer using matlab built in function
% xco =  xcorr(x,y)

% %Testing DTFT with example 1
% n=-5:10;
% a=0.5;
% u=[ones(1,16)];
% x=a.^n.*u;
% 
% N = 256;
% X = fft(x, N);
% w = 2*pi * (0:(N-1)) / N;
% w2 = fftshift(w);
% w3 = unwrap(w2 - 2*pi);
% figure(4)
% plot(w3/pi, abs(fftshift(X)))
% grid
% xlabel('radians / \pi')
