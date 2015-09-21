function [xco, dtft,engyDSpec] = ccrs(x,y,nx,ny)
%Kevin's way

%Time reverse the y matrx
flipY = fliplr(y); 

%length of x
xl = abs( nx(1) ) + abs( nx(2) ) + 1;
%length of y
yl = abs( ny(1) ) + abs( ny(2) ) + 1;

%length of final result
l = xl + yl - 1;

%Create empty matrix to store values in
M = zeros(yl,l);

%used to properly place values in correct rows and columns
spacer = 0;

%Convolution by table method
for i = 1:yl
    for j = 1:xl
        M(i,j+spacer) = [flipY(j) * x(i)];
    end
    spacer = spacer + 1;
end
xco = sum(M);

%DTFT. Currently only plots 1 period.
%Maybe figure out how to plot larger range later
%
%DTFT method taken from http://blogs.mathworks.com/steve/2010/06/25/plotting-the-dtft-using-the-output-of-fft/
N = 256;
X = fft(x, N);
w = 2*pi * (0:(N-1)) / N; 
w2 = fftshift(w);
w3 = unwrap(w2 - 2*pi);
plot(w3/pi, abs(fftshift(X)));
grid
xlabel('radians / \pi')

%fftshift(X) - |X(e^jw)|^2
engyDSpec = fftshift(X)/(2*pi)
plot(w3/pi, abs(engyDSpec))
xlabel('radians / \pi')
end