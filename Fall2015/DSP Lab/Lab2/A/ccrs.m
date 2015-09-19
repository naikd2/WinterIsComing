function xco = ccrs(x,y,nx,ny)
% function [rxy,l] = ccrs(x,y,nx,ny)

% Time reverse y 

% flipY = fliplr(y); 
% 
% l = length(nx) + length(ny)
% 
% s = nx(1);
% t = nx(length(nx));
% 
% 
% 
% 
% for c = 1:2
%     
%     for n = s:1:t
%         
%         rxy = x(n) * flipY(n)
%        
%     end
%     
% end
% 
% l = length(nx) + length(ny)


%kevin's way

% x = [1 2 3 2 1];
% y = [2 1 0 -1 -2];
% 
% %bounds of x
% nx = [-2 2];
% %bounds of y
% ny = [-2 2];


%Time reverse the y matrx
flipY = fliplr(y); 

%length of x
xl = abs( nx(1) ) + abs( nx(2) ) + 1;
%length of y
yl = abs( ny(1) ) + abs( ny(2) ) + 1;

%length of final result
l = xl + yl - 1;

M = zeros(yl,l);
spacer = 0;

for i = 1:yl
    for j = 1:xl
        M(i,j+spacer) = [flipY(j) * x(i)];
    end
    spacer = spacer + 1;
end
xco = sum(M);

%calculate DTFT
%don't know if this works
temp = w' * n;
temp = -1i * temp;

e = exp(temp);

X = e * x';

end