%% Controller selection 

%WBC
CtrlType=1;


%PD
%CtrlType=2;


%% Actuator selection

%Ideal torque
%ActType=1;

%3 axis magnetorquer
%ActType=2;

%2 axis magnetorquer
%ActType=3;

%3 axis magnetorquer.
%   Control law: Internally generates a dipole
%       m_test = (1/(norm(B_meas)^2))*(cross(B_meas,T_spec)). Computes an
%       approximation of the torque that it would generate:
%       T_test = cross(m_test,B_meas). 
%       then Calculates the angular error between this and the torque 
%       specified by the actuator: T_spec. If it less than tolerance (rad),
%       it applies it. If not, it waits.
%ActType=5;
%control_tolerance = 60 * (pi/180);

%3 axis magnetorquer
%   Computes the projection of T_spect into the plane normal to the B-field
ActType=6;

% Actuator setup
%   Specify the area and number of windings of each magnetorquer
% nAx = 2e-9; %(m^2)
% nAy = 2e-9;
% nAz = 2e-9;


nAx = 0.48; %Values similar to ClydeSpace's torquers
nAy = 0.48;
nAz = 0.48;
nA=[nAx;nAy;nAz];
%% Control setup

k=1e-9;
m=max(diag(I));
w=sqrt(k/m);
G=nthorderWTF(w,2);
adr=ADRblockGen(w,m,3);
distrej=0;

%PD
kp=5e-9;
kd=6e-4;

%% Mode select

%mode=1;%detumbling
%mode=2;%zenith pointing
mode=3;%sun facing

%q_1_ref=0;%reference for detumbling controller
%q_2_ref=0;%define reference for zenith pointing (allign with orbit frame)
q_3_ref=angle2quat(90*pi/180,0,0,'XYZ');%Allign with inertial reference frame (point towards sun);
q_ref=q_3_ref;