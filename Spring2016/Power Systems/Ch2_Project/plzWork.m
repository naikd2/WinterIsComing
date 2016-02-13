function  [I1, I2, IL] = plzWork(V1, Z1, Z2, Z3, ZL)

magZ1 = abs(Z1);
magZ2 = abs(Z2);
magZ3 = abs(Z3);

angZ1 = angle(Z1);
angZ2 = angle(Z2);
angZ3= angle(Z3);

%I1 = [abs(V1)/magZ1 angle(V1)/angZ1);

%Solve for I1
ZT = ((Z3 + ZL) * Z2)/((Z3+ZL)+Z2);
I1 = V1/(Z1 + ZT);

%Solve for V2
V2 = V1 - I1 * Z1;

%Solve for I2
I2 = V2/Z2;

%Solve for IL
IL = V2/(Z3 + ZL);


%Calculate Power Loss
%Power loss is power in all other components besides load?
PLoss = (I1^2 * Z1) + (I2^2 * Z2) + (IL^2 * Z3);


%Convert to phasors
I1 = [abs(I1) angle(I1)];
I2 = [abs(I2) angle(I2)];
IL = [abs(IL) angle(IL)];


end

% % j = sqrt(-1)
% % 240 / ( ( 10 + j*5 ) + (  ( 1 + j*1) * (j*2.5 +2 +1*j)) / (1+j*1 + j*2.5+2 + 1*j )    )
% % 
% % 

