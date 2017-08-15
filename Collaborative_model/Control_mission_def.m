%% Controller selection 

%WBC
CtrlType=1;


%PD
%CtrlType=2;

%% Control setup

k=1e-6;
m=max(diag(I));
w=sqrt(k/m);
G=nthorderWTF(w,2);
adr=ADRblockGen(w,m,3);
distrej=0;

%PD
kp=5e-9;
kd=6e-4;

%% Mode select

mode=1;%detumbling
%mode=2;%zenith pointing
%mode=3;%sun facing

q_ref=angle2quat(0,0,0,'XYZ');