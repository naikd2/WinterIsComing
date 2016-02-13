function  [I1, I2, I3] = plzWork(V1, Z1, Z2, Z3, ZL)

magZ1 = abs(Z1);
magZ2 = abs(Z2);
magZ3 = abs(Z3);

angZ1 = angle(Z1);
angZ2 = angle(Z2);
angZ3= angle(Z3);

I1 = [abs(V1)/magZ1 angle(V1)/angZ1);



end

% % j = sqrt(-1)
% % 240 / ( ( 10 + j*5 ) + (  ( 1 + j*1) * (j*2.5 +2 +1*j)) / (1+j*1 + j*2.5+2 + 1*j )    )
% % 
% % 
