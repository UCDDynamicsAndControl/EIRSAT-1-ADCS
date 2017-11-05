Ix=I(1,1);
Iy=I(2,2);
Iz=I(3,3);

sx=(Iy-Iz)/Ix;
sy=(Iz-Ix)/Iy;
sz=(Ix-Iy)/Iz;

%Example B field vector (lat=0...long=0...alt=405km)
% Bx=2.2614e-05;
% By=-2.3408e-06;
% Bz=-1.1483e-05;

Bx=1.075e-5;
By=-3e-6;
Bz=-2.263e-5;

B_vect_lin=[Bx;By;Bz];
Sb=SkewSym(B_vect_lin);

% coil_area=[Ax;Ay;Az];
% coil_turns=[Nx;Ny;Nz];
coils=[nAx;nAy;nAz];%coil_area.*coil_turns;

w_o=omega_orbit(2);

%%state vector x=[d_eta_1,d_eta_2,d_eta_3,w1,w2,w2]^T

A_lin=[0,            0,            0,          1,           0,             0;...
       0,            0,            0,          0,           1,             0;...
       0,            0,            0,          0,           0,             1;...
      -4*sx*(w_o^2), 0,            0,          0,           0,             (1-sx)*w_o;...
       0,            0,            0,          0,           -3*sy*(w_o^2), 0;...
       0,            0,            -sz*(w_o^2),-(1-sz)*w_o, 0,             0];

%inputs: u=[m_coil_x,m_coil_y,m_coil_z];   
   
B_lin=[0          ,0         ,0;...
       0          ,0         ,0;...
       0          ,0         ,0;...
       0          ,Bz/(2*Ix) ,-By/(2*Ix);...
       -Bz/(2*Iy) ,0         ,Bx/(2*Iy);...
       By/(2*Iz)  ,-Bx/(2*Iz),0           ];

%outputs: all states;

C_lin=eye(6);

lin_mod=ss(A_lin,B_lin,C_lin,0);

A_lin_cl=A_lin-((1/(norm(B_vect_lin)^2))*((kp*B_lin*Sb*C_lin(1:3,:))+(kd*B_lin*Sb*C_lin(4:6,:))));

CL_tf=ss(A_lin_cl,B_lin,C_lin,0);