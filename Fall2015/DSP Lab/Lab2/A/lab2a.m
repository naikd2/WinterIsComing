
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


% %length of x
% xl = abs( nx(1) ) + abs( nx(2) ) + 1
% %length of y
% yl = abs( ny(1) ) + abs( ny(2) ) + 1
% 
% %length of final result
% l = xl + yl - 1;

% nxMat = nx(1):1:nx(2)
% nyMat = ny(1):1:ny(2)
% 
% XMat2d = [nxMat ; x]
% YMat2d = [nyMat ; y]
% 
% 
% rxy = ones(1,l);
% 
% for c = 1:l
%     for n = 1:xl
%         rxy(c) = x(n) * flipY(c - n + 1);
%     end
%     
% end



%Probably garbage. Delete later
% for c = 1:l
%     matList(c) = [flipY(c) * x(c)]
% end
%Sum = sum(matList)


%Kevin's way
%create matrix filled with 0's
%store values within matrix
%multiply
%add up columns

% M = zeros(yl,l)
% %used to make sure correct columns are added up
% spacer = 0;
% 
% for i = 1:yl
%     for j = 1:xl
%         M(i,j+spacer) = [flipY(j) * x(i)];
%     end
%     spacer = spacer + 1;
% end
% M
% sum(M)

ccrs(x,y,nx,ny)

%Actual Answer using matlab built in function
% xco =  xcorr(x,y)
