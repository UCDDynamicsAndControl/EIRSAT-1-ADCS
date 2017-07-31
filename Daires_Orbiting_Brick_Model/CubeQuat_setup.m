%Reference frames: 
%-Body fixed frame. rigidly attached to body,centred on CoM satellite
%-obit fixed frame or orbit frame. Centred to CoM of satellite. z_axis
% points towars ground. x points prograde. y points perpendicular to x
%-Inertial reference frame positioned at centre of the earth

% state vector is made of:
%-angular velocity of the body fixed frame wrt the inertial frame 
%-the quaternion which represents the rotation between body fixed frame and
% the orbital frame
% 
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
I=diag([1;1;1]);

omega_orbit=[0;-7.67/(401.1+6371);0];%define orbit angular velocity. This is 
%for a ISS like orbit, but around the equator.

% A PD which gives good results.
kp=40;
kd=2*sqrt(I(1,1))*sqrt(kp);

%WBC controller which gives similar results;
k=40;%notional spring stiffness
G=nthorderWTF(sqrt(k/I(1,1)),3);%create WTF going through itirative twice;
adr=ADRblockGen(wo,I(1,1),3);%active disturbance rejection for WBC
distrej=1;%turn on the disturbance rejection. set =0 to turn off

