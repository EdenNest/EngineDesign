clc;clear all
ALT=0;
%ALT dependent parameters

if ALT<11000
        T1= (15.04+273.15-0.00649*ALT);
        P1= 101.325.*(T1/288.15)^(9.81/(0.0065*287.05));


elseif (11000<ALT)&&(ALT<25000)
         T1= 216.69;
         P1= 11650;

else
        T1= 273.15-131.21+0.00299*ALT;
        P1= (2.488*((T1)/216.6)^-11.388)*1000;
end


gamma=1.38;
m_dot_corrected=1.7; %kg/s HPC
CPR=5.5;
FPR=1.2;
N1=50000; %RPM
N2=33000; %RPM
RPM_percent=1;
ec=0.9; %compressor polytropic efficiency
Ca=150;
alpha=10/180*pi;
M0=150*cos(alpha)/sqrt(1.4*287*T1);
P01=P1*(1+0.2*M0^2)^(1.4/0.4);
T01=T1*(1+0.2*M0^2);


P02=P01*FPR;
T02=T01*FPR^(0.4/1.4);
hub_tip=0.5;
m_dot=m_dot_corrected.*P02./P1...
    ./sqrt(T02./T1);
M1=M0;

M1=0.4
gamma=1.4;
M1=283.21/sqrt(gamma*287*(340-283.21^2/(2*(1.38*287)/0.38)))
MFP=sqrt(gamma)*M1*...
    (1+(gamma-1)/(2)*M1^(2))^(-((gamma+1))/(2*(gamma-1)));
A=m_dot*sqrt(287*T02)/P02/1000/MFP;
A=4.7*sqrt(287*445.39)/3.88/100000/MFP
rt=sqrt(A/pi/(1-hub_tip^2))
u_tip=rt*N1*RPM_percent/60*2*pi;
M_tip=sqrt(u_tip^2+Ca^2)/sqrt(1.4*287*T1)
T03=T02.*(CPR).^(0.4/1.4./ec);
P03=P02*CPR;
%M3=Ca/sqrt(1.4*287*(T02-Ca^2/2/1006))
%MFP=sqrt(gamma)*M3*...
 %   (1+(gamma-1)/(2)*M3^(2))^(-((gamma+1))/(2*(gamma-1)));
%A_exit=m_dot*sqrt(287*T03)/P03/1000/MFP;
TotalDeltaT=T03-T01
B1=atan(u_tip/Ca);
%B1=atan(u_tip/Ca)*180/pi;
V1=Ca/cos(B1);
V2=0.72*V1;
B2=acos(Ca/V2);
deltaT_stage=1/1006*u_tip*Ca*(tan(B1)-tan(B2))
stages=TotalDeltaT/deltaT_stage
MFP
A



