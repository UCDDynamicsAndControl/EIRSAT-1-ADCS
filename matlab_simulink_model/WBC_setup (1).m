%WBC controller setup which works. setting w so high might noth make sense
%but gives good results. disturbance rejection can be turned on and off.
%there is more over shoot with dist rej, but the system settles quicker

a=10;%10;

k=5e-9;
m=max(diag(I));
w=sqrt(a*k/m);
G=nthorderWTF(w,2);
adr=ADRblockGen(w,m,3);


k2=5e-9;
m2=min(diag(I));
w2=sqrt(a*k2/m2);
G2=nthorderWTF(w2,2);
adr2=ADRblockGen(w2,m,3);

distrej=1;