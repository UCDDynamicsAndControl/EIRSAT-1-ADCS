% state vector is made of angular velocities about inertial ref frame axes 
% and the rotation between inertial and body fixed frame, expressed as a 
% quaternion
% x=[omega_x,omega_y,omega_z,q_1,q_2,q_3,q_4];

% Use one of the two options for initial conditions. Swap between the two
% by throwing the switch in the simulink model
x_0=[0,0,0,1,0,0,0];
% or
omega_0=[0;0;0];
euler_init=[0;0;0];%will be converted to a quaternion in simulink & fed into model

%Ensures that the torque input to the model, M, is always a 3x1 vector;
M=zeros(3,1);

%define inertia matrix
I=diag([10;10;10]);

% A PD which gives good results.
kp=40;
kd=2*sqrt(I(1,1))*sqrt(kp);

%WBC controller which gives similar results;
k=40;%notional spring stiffness
G=nthorderWTF(sqrt(k/I(1,1)),3);%create WTF going through itirative twice;
