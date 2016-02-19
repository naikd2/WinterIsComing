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
V2 = V1 - (I1 * Z1);

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

%Part 2
V3 = V2 - (IL * ZL);
PL = V3 * IL * cos(angle(V3) - angle(IL));
QL = V3 * IL * sin(angle(IL - V3));

SL = P + Q;
QC = -(QL);

S = V3^2/(-QC);

XC = S;


%Part 3
%Solve for I1
newZT = (ZL * XC)/ (ZL + XC);
newZT = ((Z3 + newZT) * Z2)/((Z3+newZT)+Z2);
newI1 = V1/(Z1 + newZT);

%Solve for V2
newV2 = V1 - (newI1 * Z1);

%Solve for I2
newI2 = V2/Z2;

%Solve for IL
newIL = V2/(Z3 + ZL);

%Solve for apparent Power SL
newV3 = newV2 - (newIL * newZL);
PL = V3 * IL * cos(angle(V3) - angle(IL));
QL = V3 * IL * sin(angle(IL - V3));

SL = P + Q;
end



