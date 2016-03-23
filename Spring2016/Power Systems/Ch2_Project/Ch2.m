
j = 1i;

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

ZLP = (ZL * Xpfc) / (ZL + Xpfc)  + Z3;

nZT = ( (ZLP * Z2) / (ZLP + Z2) ) + Z1;

%Solve for I1
nI1 = V1 / nZT;

%Solve for V2
nV2 = V1 - (nI1 * Z1);

%Solve for I2
nI2 = nV2/Z2;

%Solve for I3
nI3 = nV2 / ZLP;

%Solve for IL
nV3 = nV2 - nI3 * Z3;
nIL = nV3 / ZL;
nIx = nV3 / Xpfc;

nI1ph = Phasor(nI1);
nI2ph = Phasor(nI2);
nI3ph = Phasor(nI3);
nILph = Phasor(nIL);
nIxph = Phasor(nIx);
nV2ph = Phasor(nV2);
nV3ph = Phasor(nV3);

% Complex Power 
nLoadphi = nV3ph(2) - nILph(2);
nXphi = nV3ph(2) - nIxph(2);
nPload = nV3ph(1) * nILph(1) * cosd(nLoadphi);
nQload =  nV3ph(1) * nILph(1) * sind(nLoadphi);

nPx = nV3ph(1) * nIxph(1) * cosd(nXphi);
nQx =  nV3ph(1) * nIxph(1) * sind(nXphi);

nSload = nPload + j*nQload;
nSx = nPx + j*nQx;
nSload_app = sqrt( (nPload*nPload)  + (nQload * nQload));

nPtotal = V1 * nI1ph(1) * cosd( -1* (nI1ph(2)));
nPload = nV3ph(1) * nILph(1) * cosd(nLoadphi);
nPloss = nPtotal - nPload;
nratio = nPloss / nPload;

I1 = Phasor(I1);
I2 = Phasor(I2);
IL = Phasor(IL);


