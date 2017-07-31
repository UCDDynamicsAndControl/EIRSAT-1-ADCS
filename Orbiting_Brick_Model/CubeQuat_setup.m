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
% q_1 = eta
%[q_2,q_3,q_4] = epsilon

% Use one of the two options for initial conditions. 
% Set in_cond_selec = 1 if you want to define x_0 or
% Set in_cond_selec = 0 if you want to define omega_0 and euler_init
in_cond_selec = 0;
%
x_0=[0,0,0,1,0,0,0];
% or
omega_0=[0;0;0];
euler_init=[pi/4;pi/4;pi/4];%will be converted to a quaternion in simulink & fed into model

%Ensures that the torque input to the model, M, is always a 3x1 vector;
M=zeros(3,1);

%define inertia matrix
I_mom = [1,1,1]; %Moments of inertia (Kg*m^2) in the form [I_xx, I_yy, I_zz]
I_prd = [0,0,0]; %Products of inertia (Kg*m^2) in the form [I_xy, I_xz, I_yz]
I = diag(I_mom) + [0 I_prd(1) I_prd(2); I_prd(1) 0 I_prd(3); I_prd(2) I_prd(3) 0];

omega_orbit=[0;-7.67/(401.1+6371);0];%define orbit angular velocity. This is 
%for a ISS like orbit, but around the equator.


% Set control_selec = 1 for PD controller, or
% Set control_selec = 0 for WBC controller
control_selec = 0;

% A PD which gives good results.
kp=40;
kd=2*sqrt(I(1,1))*sqrt(kp);

%WBC controller which gives similar results;
k=40;%notional spring stiffness
G=nthorderWTF(sqrt(k/I(1,1)),3);%create WTF going through itirative twice;

wo = k/I(1,1); % (!!!)  

adr=ADRblockGen(wo,I(1,1),3);%active disturbance rejection for WBC
distrej=1;%turn on the disturbance rejection. set =0 to turn off