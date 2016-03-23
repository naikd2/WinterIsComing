clear all
close all

j = 1i;
f = 60;
omega = 2*pi*f;

Phasor = inline('[abs(z) radtodeg(angle(z))]','z');


%   Step 9/10
% (Amplitude, Zero Crossing, RMS, dt, angle)
vGen = [59.73, 1.00044, 0, 0, 0];
vLoad = [36.45, 1.00178, 0, 0, 0];
iGen = [6.95, 1.00115, 0, 0, 0];
iLoad = [7.30, 1.00180, 0, 0, 0];
%   RMS
vGen(3) = (sqrt(3)/sqrt(2)) * vGen(1);
vLoad(3) = (sqrt(3)/sqrt(2)) * vLoad(1);
iGen(3) = (sqrt(3)/sqrt(2)) * iGen(1);
iLoad(3) = (sqrt(3)/sqrt(2)) * iLoad(1);
%   delta T
vGen(4) = 0;
vLoad(4) = vLoad(2)-vGen(2);
iGen(4) = iGen(2)-vGen(2);
iLoad(4) = iLoad(2)-vGen(2);
%   angle
vGen(5) = 0;
vLoad(5) = 360 * vLoad(4)/(1/f);
iGen(5) = 360 * iGen(4)/(1/f);
iLoad(5) = 360 * iLoad(4)/(1/f);

%   Step 11
%   (RMS LN, Phase Angle)
PHvGen = [ vGen(1)/sqrt(2) , -vGen(5)];
PHvLoad = [ vLoad(1)/sqrt(2) , -vLoad(5)];
PHiGen = [ iGen(1)/sqrt(2) , -iGen(5)];
PHiLoad = [ iLoad(1)/sqrt(2) , -iLoad(5)];

%   Step 12
%   Polar
sGen_P = [0, 0];
sGen_P(1)= PHvGen(1) * PHiGen(1);
sGen_P(2)= PHvGen(2) - PHiGen(2);
sLoad_P = [0, 0];
sLoad_P(1)= PHvLoad(1) * PHiLoad(1);
sLoad_P(2)= PHvLoad(2) - PHiLoad(2);
%   Polar to Rectangular
sGen_R = sGen_P(1) * cosd(sGen_P(2)) +  j* sGen_P(1) * sind(sGen_P(2))
sLoad_R = sLoad_P(1) * cosd(sLoad_P(2)) +  j* sLoad_P(1) * sind(sLoad_P(2))

%   Step 14
sLoss = sGen_R - sLoad_R;

%   Step 15a
%   For sinusoidal (non-distorted) currents, 
%   the displacement power factor 
%   is the same as the apparent power factor

DPF = cosd(15.33);

zLoad = 5 + 0*j;
zRLine = 2.5 + 0*j;
zXLine = 10*10E-3 * omega * j;
zCLine1 = 1 / (50*10E-6 *omega * j);
zCLine2 = 1 / (50*10E-6 *omega * j);
zEq = 0;

zEq = (zLoad * zCLine1) /  (zLoad + zCLine1);
zEq = zEq + zRLine + zXLine;
zEq = (zEq * zCLine2) /  (zEq + zCLine2);

Z = (42.235*42.235) /54.9;
Z = -Z*j
Cpfc = 1/(j*omega*Z);

% Step 20 
% Zero Crossings:
% VGen = 459us
% IGen = 472us
% (Zero Crossing, dt, angle)
UPvGen = [1.000459, 0, 0];
UPiGen = [1.000472, 0, 0];
%   delta T
UPvGen(2) = 0;
UPiGen(2) = UPiGen(1)-UPvGen(1);
%   angle
UPvGen(3) = 0;
UPiGen(3) = 360 * UPiGen(2)/(1/f);
% angle 0.2808 degrees for iGen0






