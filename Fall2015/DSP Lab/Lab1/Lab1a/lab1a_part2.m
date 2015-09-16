

% loads handel sound file into variable hfile
load handel.mat;
hfile = 'handel.wav';
% x = output matrix
% Fs = sample rate
% nbits = bits per sample
[y, Fs, nbits] = wavread(hfile);
%sound(y,8192)

% % a) select every other sample in x and play the new sound array at half
% % the sampling rate
% 
% % puts ever 2nd element of y into array x
% x = y(1:2:length(y));
% % half of 8192 is 4096
% sound(x,4096)
% 
% % b) select every fourth sample in x and play the new sound array at quater
% % the sampling rate
% 
% % puts ever 2nd element of y into array x
% x = y(1:4:length(y));
% % a fourth of 8192 is 2048
% sound(x,2048)

% b) Set each new sampled value as the average of the old value of that
% signal and the values before and after.


