% function  [I1, I2, IL] = plzWork(V1, Z1, Z2, Z3, ZL)
clear all
close all

j = 1i;

V1 = 240 + j*0;
Z1 = 10 + j*5;
Z2 = 1 + j;
Z3 = j*2.5;
ZL = 2 + j;

Phasor = inline('[abs(z) radtodeg(angle(z))]','z');

%Part 1

%Find total Impedence in CKT
ZT = ZL + Z3;
ZT = (ZT * Z2) / (ZT + Z2);
ZT = ZT + Z1;

%Solve for I1
I1 = V1 / ZT;

%Solve for V2
V2 = V1 - (I1 * Z1);

%Solve for I2
I2 = V2/Z2;

%Solve for IL
IL = V2/(Z3 + ZL);
V3 = IL * ZL;



I1ph = Phasor(I1);
I2ph = Phasor(I2);
ILph = Phasor(IL);
V3ph = Phasor(V3);
V2ph = Phasor(V2);
V1ph = Phasor(V1);


%Calculate Power Loss
%Find Total Power in CKT

Ptotal = V1 * I1ph(1) * cosd( -1* (I1ph(2)));
Loadphi = V3ph(2) - ILph(2);
Pload = V3ph(1) * ILph(1) * cosd(Loadphi);
Ploss = Ptotal - Pload;
ratio = Ploss / Pload;

% %Part 2

Pload = V3ph(1) * ILph(1) * cosd(Loadphi);
Qload =  V3ph(1) * ILph(1) * sind(Loadphi);

Sload = Pload + j*Qload;
Sload_app = sqrt( (Pload*Pload)  + (Qload * Qload));

Z = (V3ph(1))^2 / ( -Qload); 
Xpfc = Z*j;

Xph = Phasor(Xpfc);

%Part 3
nZL = (ZL * Xpfc) / ( ZL + Xpfc);
nZT = nZL + Z3;
nZT = (nZT * Z2) / (nZT + Z2);
nZT = nZT + Z1;

%Solve for I1
nI1 = V1 / nZT;
%Solve for V2
nV2 = V1 - (nI1 * Z1);
%Solve for I2
nI2 = nV2/Z2;
%Solve for IL
nIL = nV2/(Z3 + nZL);
nV3 = nIL * nZL;

nI1ph = Phasor(nI1);
nI2ph = Phasor(nI2);
nILph = Phasor(nIL);
nV3ph = Phasor(nV3);
nV2ph = Phasor(nV2);

nLoadphi = nV3ph(2) - nILph(2);

nPload = nV3ph(1) * nILph(1) * cosd(nLoadphi);
nQload =  nV3ph(1) * nILph(1) * sind(nLoadphi);

nSload = nPload + j*nQload;
nSload_app = sqrt( (nPload*nPload)  + (nQload * nQload));

nPtotal = V1 * nI1ph(1) * cosd( -1* (nI1ph(2)));
nPload = nV3ph(1) * nILph(1) * cosd(nLoadphi);
nPloss = nPtotal - nPload;
nratio = nPloss / nPload;


% end



