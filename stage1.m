clc;clear all
gamma=1.38;
cp=(gamma*287)/(gamma-1);

deltaT=23;
wdf=0.98;
U=226.27;
eff=1;
T01=359.65;
ca=150;

deltaCw=cp*deltaT/wdf/U;
cw2=deltaCw;
B1=atan(U/ca);
B2=atan((U-cw2)/ca);
a2=atan(cw2/ca);
dehaller_rotor=cos(B1)/cos(B2)


P03_P01=(1+eff*deltaT/T01)^(gamma/(gamma-1))
T03=T01+deltaT

R=1-cw2/2/U
R2=0.7;

deltaT2=25;wdf2=0.93;
syms B1_2 B2_2
E=[deltaT2==wdf2/cp*U*ca*(tan(B1_2)-tan(B2_2)),...
    R2==ca/2/U*(tan(B1_2)+tan(B2_2))];
[B1_2 , B2_2]=solve(E,B1_2 , B2_2);



B1_2=double(B1_2*180/pi);
B2_2=double(B2_2*180/pi);
a1_2=atan((U-ca*tan(B1_2))/ca);
a2_2=atan((U-ca*tan(B2_2))/ca);
a3=a1_2;


dehaller_stator=cos(a2)/cos(a3)

%display
B1_1=B1*180/pi
B2_1=B2*180/pi
a1_1=0
a2_1=a2*180/pi
a3_1=a3*180/pi

B1_2
B2_2
a1_2=a1_2*180/pi
a2_2*180/pi


