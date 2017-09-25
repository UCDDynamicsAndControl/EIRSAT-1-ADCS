function [ xdot ] = OrbitModel( x,omega_orbit,wb_bi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% state info

% current state vector

long=x(1);% From West to East (+-180) East is pos
lat=x(2);% From North to South (+-90deg) North is pos
Alt=x(3);

% quaternion rep rotation between body frame and orbit frame
q_o=x(4:7);
n_o=q_o(1);
eta_o=q_o(2:4);


%quat rep rotation between orbital frame and inertial frame
qoi=x(8:11);
n_oi=qoi(1);
eta_oi=qoi(2:4);



%% rotaton between frames

% between body and orbit frame
S_o=SkewSym(eta_o);
Ro_b=eye(3)+(2*n_o*S_o)+(2*(S_o^2));%from body to orbit frame
Rb_o=transpose(Ro_b);%from orbit to body frame


% define the angular velocity of the body frame wrt orbital frame.
omegab_ob=wb_bi-(Rb_o*(omega_orbit));
S_oi=SkewSym(eta_oi);

%% Differential Equations of Motion


%q meas wrt orbit frame
n_o_dot=-0.5*transpose(eta_o)*omegab_ob;
eta_o_dot=0.5*((n_o*eye(3))+S_o)*omegab_ob;
%q representing rotation between orbital n inertail frame
noidot=-0.5*transpose(eta_oi)*(omega_orbit);
etaoidot=0.5*((n_oi*eye(3))+S_oi)*(omega_orbit);

long_dot=omega_orbit(2);
lat_dot=sqrt((omega_orbit(1)^2)+(omega_orbit(3)^2));
Alt_dot=0;%const altitude

xdot=[long_dot;lat_dot;Alt_dot;n_o_dot;eta_o_dot;noidot;etaoidot];

end

