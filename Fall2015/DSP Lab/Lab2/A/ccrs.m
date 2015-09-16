function [rxy,l] = ccrs(x,y,nx,ny)
% Time reverse y 

flipY = fliplr(y); 

l = length(nx) + length(ny)

s = nx(1);
t = nx(length(nx));




for c = 1:l
    
    for n = s:1:t
        
        rxy = x(n) * flipY(n)
       
    end
    
end

l = length(nx) + length(ny)

end