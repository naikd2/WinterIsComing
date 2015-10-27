clear
figure (1)
x = [0 1 2 3];
n1 = 4;

X = fft(x, n1);
M = abs(X);
subplot(3, 1, 1)
stem(x, 'linewidth', 1.75)
title('x[n]')

subplot(3, 1, 2)
stem(M, 'linewidth', 1.75)
title('X[k]')

InvX = ifft(X, n1);
subplot(3, 1, 3)
stem(InvX, 'linewidth', 1.75)
title('x[n]')




figure (2)
n2 = 8;
X = fft(x, n2);
M = abs(X);
subplot(3, 1, 1)
stem(x, 'linewidth', 1.75)
title('x[n]')

subplot(3, 1, 2)
stem(M, 'linewidth', 1.75)
title('X[k]')

InvX = ifft(X, n2);
subplot(3, 1, 3)
stem(InvX, 'linewidth', 1.75)
title('x[n]')





figure (3)
g = [1 2 3 4 5];
h = [2 2 0 1 1];
L=length(g)+length(h)-1;

subplot(3, 2, 1)
stem(g, 'linewidth', 1.75)
title('g[n]')

subplot(3, 2, 3)
stem(h, 'linewidth', 1.75)
title('h[n]')


G = fft(g, L);
subplot(3, 2, 2)
stem(abs(G), 'linewidth', 1.75)
title('G[k]')
 
H = fft(h, L);
subplot(3, 2, 4)
stem(abs(H), 'linewidth', 1.75)
title('H[k]')
 
Y = G .* H;
M = abs(Y);
subplot(3, 2, 6)
stem(M, 'linewidth', 1.75)
title('G[k]H[k]')
 
y=ifft(Y);
subplot(3, 2, 5)
stem(y, 'linewidth', 1.75)
title('g[n] * h[n]')
