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
newPLoss1 = abs(V1-V2) * abs(I1) * cosd(radtodeg(angle(V1-V2)) - radtodeg(angle(I1)))
newPLoss2 = abs(V2) * abs(I2) * cosd(radtodeg(angle(V2)) - radtodeg(angle(I2)))
newPLoss3 = abs(V2) * abs(IL) * cosd(radtodeg(angle(V2)) - radtodeg(angle(IL)))
newPLoss = newPLoss1 + newPLoss2 + newPLoss3


%Part 2
V3 = V2 - (IL * Z3);
PL = abs(V3) * abs(IL) * cosd(radtodeg(angle(V3)) - radtodeg(angle(IL)));
QL = abs(V3) * abs(IL) * sind(radtodeg(angle(V3)) - radtodeg(angle(IL)));



SL = PL + j*QL
QC = -(QL)


Z = (abs(V3))^2/(j*-QC)

Xpfc = Z
% Xpfc = [abs(Z) radtodeg(angle(Z))]


%Part 3
%Solve for I1
newZL = (ZL * Xpfc)/ (ZL + Xpfc);
newZT = ((Z3 + newZL) * Z2)/((Z3 + newZL) + Z2);
newI1 = V1/(Z1 + newZT);

%Solve for V2
newV2 = V1 - (newI1 * Z1);

%Solve for I2
newI2 = newV2/Z2;

%Solve for IL
newIL = newV2/(Z3 + newZL);

%Solve for apparent Power SL
newV3 = newV2 - (newIL * newZT);
newPL = abs(newV3) * abs(newIL) * cosd(radtodeg(angle(newV3)) - radtodeg(angle(newIL)));
newQL = abs(newV3) * abs(newIL) * sind(radtodeg(angle(newV3)) - radtodeg(angle(newIL)));



newSL = newPL + j*newQL;


newPLoss1 = abs(newV1-newV2) * abs(newI1) * cosd(radtodeg(angle(newV1-newV2)) - radtodeg(angle(newI1)))
newPLoss2 = abs(newV2) * abs(newI2) * cosd(radtodeg(angle(newV2)) - radtodeg(angle(newI2)))
newPLoss3 = abs(newV2) * abs(newIL) * cosd(radtodeg(angle(newV2)) - radtodeg(angle(newIL)))
newPLoss = newPLoss1 + newPLoss2 + newPLoss3

%Part 4
%Comparing Ratios
ratio = PLoss / PL;
newRatio = newPLoss/newPL;


%Convert to phasors
I1 = [abs(I1) radtodeg(angle(I1))];
I2 = [abs(I2) radtodeg(angle(I2))];
IL = [abs(IL) radtodeg(angle(IL))];
end



