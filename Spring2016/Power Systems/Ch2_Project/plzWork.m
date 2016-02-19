function  [I1, I2, IL] = plzWork(V1, Z1, Z2, Z3, ZL)

%Part 1
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
PL = (V3/sqrt(2)) * (IL/sqrt(2)) * cos(angle(V3) - angle(IL));
QL = (V3/sqrt(2)) * (IL/sqrt(2)) * sin(angle(IL - V3));

SL = PL + QL;
QC = -(QL);

S = V3^2/(-QC);

XC = S;


%Part 3
%Solve for I1
newZT = (ZL * XC)/ (ZL + XC);
newZT = ((Z3 + newZT) * Z2)/((Z3 + newZT) + Z2);
newIL = V1/(Z1 + newZT);

%Solve for V2
newV2 = V1 - (newIL * Z1);

%Solve for I2
newI2 = V2/Z2;

%Solve for IL
newIL = V2/(Z3 + newZT);

%Solve for apparent Power SL
newV3 = newV2 - (newIL * newZT);
newPL = (newV3/sqrt(2)) * (newIL/sqrt(2)) * cos(angle(newV3) - angle(newIL));
newQL = (newV3/sqrt(2)) * (newIL/sqrt(2)) * sin(angle(newIL) - angle(newV3));

newSL = newPL + newQL;

newPLoss = (newI1^2 * Z1) + (newI2^2 * Z2) + (newIL^2 * Z3);

%Part 4
%Comparing Ratios
ratio = PLoss/PL;
newRatio = newPLoss/newPL;
end



