clear

%Part 1-2
%Calculating the 4 point DFT
figure (1)
x = [0 1 2 3];
n1 = 4;

%Plot input sequence x[n]
subplot(3, 1, 1)
stem(x, 'linewidth', 1.75)
title('x[n]')

%Calculate and plot the magnitude of the X[k]
X = fft(x, n1);
M = abs(X);
subplot(3, 1, 2)
stem(M, 'linewidth', 1.75)
title('X[k]')

%Calculate and plot the inverse DFT of X[k] to retrieve the original signal
InvX = ifft(X, n1);
subplot(3, 1, 3)
stem(InvX, 'linewidth', 1.75)
title('x[n]')





%Part 3
%Calculating the 8 point DFT
figure (2)
n2 = 8;

%Plot the input sequence x[n]
subplot(3, 1, 1)
stem(x, 'linewidth', 1.75)
title('x[n]')

%Calculate and plot the magnitude of the X[k]
X = fft(x, n2);
M = abs(X);
subplot(3, 1, 2)
stem(M, 'linewidth', 1.75)
title('X[k]')

%Calculate and plot the inverse DFT of X[k] to retrieve the original signal
InvX = ifft(X, n2);
subplot(3, 1, 3)
stem(InvX, 'linewidth', 1.75)
title('x[n]')





%Part 4-5
%Calculating the convolution of g[n] and h[n] using the DFT method
figure (3)
g = [1 2 3 4 5];
h = [2 2 0 1 1];
L=length(g)+length(h)-1;

%Plot the input sequence g[n]
subplot(3, 2, 1)
stem(g, 'linewidth', 1.75)
title('g[n]')

%Plot the input sequence h[n]
subplot(3, 2, 3)
stem(h, 'linewidth', 1.75)
title('h[n]')


%Calculate and plot G[k]
G = fft(g, L);
subplot(3, 2, 2)
stem(abs(G), 'linewidth', 1.75)
title('G[k]')
 
%Calculate and plot H[k]
H = fft(h, L);
subplot(3, 2, 4)
stem(abs(H), 'linewidth', 1.75)
title('H[k]')

%Calculate and plot Y[k]
Y = G .* H;
M = abs(Y);
subplot(3, 2, 6)
stem(M, 'linewidth', 1.75)
title('G[k]H[k]')

%Take the inverse DFT of Y[k] to retrive y[n]
y=ifft(Y);
subplot(3, 2, 5)
stem(y, 'linewidth', 1.75)
title('g[n] * h[n]')
