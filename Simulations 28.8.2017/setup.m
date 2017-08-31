% ___Controller selection 
%WBC
CtrlType=1; % All simulations ran with WBC

%PD
%CtrlType=2;

% ___Actuator selection
% Everything commented here, as the actuator will change
%Ideal torque
%ActType=1;

%3 axis magnetorquer
ActType=2; % Every simulation is done with this actuator

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
%ActType=6;

%__ Actuator setup
%  Specify the area and number of windings of each magnetorquer
nAx = 0.2436; % These will be the same through all the simulations
nAy = 0.2436;
nAz = 0.2436;

%__Control setup
% k = 5e-8; % These are variables in the 'for' loops
% m = max(diag(I));
% w = sqrt(2*k/m);
G = nthorderWTF(w,2);
adr = ADRblockGen(w,m,3);
distrej = 0;

%PD
%kp=5e-9;
%kd=6e-4;

%__ Mode select % All simulations will do sun facing
%mode=1;%detumbling
%mode=2;%zenith pointing
%mode=3;%sun facing

%q_1_ref=0;%reference for detumbling controller
%q_2_ref=0;%define reference for zenith pointing (allign with orbit frame)
q_3_ref=angle2quat(0,0,0,'XYZ');%Allign with inertial reference frame (point towards sun);
q_ref=q_3_ref;

%% Initial state 

wb_bi_init=[0,0,0];%init ang vel of body frame wrt inertial frame
qb_o_init=angle2quat(0,0,0,'XYZ');
%qb_i_init=angle2quat(0.1,0,0,'XYZ'); % These is a variable in the 'for' loop
qo_i_init=angle2quat(0,0,0,'XYZ');
lat_init=0;
long_init=0;

x_0=transpose([wb_bi_init,qb_i_init]);%inital state vector of satelite 
x_orbit_init=[long_init,lat_init,altitude,qb_o_init,qo_i_init];%initial orbit parameters

