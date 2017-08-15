function [ xdot ] = CubeSatModel( x,I,omega_orbit,T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% state info

% current state vector
omegab_ib=x(1:3);%angular vel of bod frame wrt inert frame
% quaternion rep rotation between body frame and orbit frame
q_o=x(4:7);
n_o=q_o(1);
eta_o=q_o(2:4);
% quaternion re rotation between body frame and inertial frame
q_i=x(8:11);
n_i=q_i(1);
eta_i=q_i(2:4);

%quat rep rotation between orbital frame and inertial frame
qoi=x(12:15);
n_oi=qoi(1);
eta_oi=qoi(2:4);

long=x(16);% From West to East (+-180) East is pos
lat=x(17);% From North to South (+-90deg) North is pos
Alt=x(18);

%% rotaton between frames

% between body and orbit frame
S_o=SkewSym(eta_o);
Ro_b=eye(3)+(2*n_o*S_o)+(2*(S_o^2));%from body to orbit frame
Rb_o=transpose(Ro_b);%from orbit to body frame
c_3=Rb_o(:,3);%needed for gravity gradient


% between body and inertial frames
S_i=SkewSym(eta_i);
Ri_b=eye(3)+(2*n_i*S_i)+(2*(S_i^2));%from body to inertial frame
Rb_i=transpose(Ri_b);

% between orbital and inertial
Ro_i=Ro_b*Rb_i;
Ri_o=transpose(Ro_i);
%er_i=Ri_o*[0.1;0.2;0.3];

% define the angular velocity of the body frame wrt orbital frame.
omegab_ob=omegab_ib-(Rb_o*omega_orbit);
S_oi=SkewSym(eta_oi);

%% Differential Equations of Motion

%derivative of omega of body frame wrt inertial frame
omega_ib_dot=I\(-cross(omegab_ib,I*omegab_ib)+T);%+T_ext);
%q meas wrt orbit frame
n_o_dot=-0.5*transpose(eta_o)*omegab_ob;
eta_o_dot=0.5*((n_o*eye(3))+S_o)*omegab_ob;
%q meas wrt inertial frame
n_i_dot=-0.5*transpose(eta_i)*omegab_ib;
eta_i_dot=0.5*((n_i*eye(3))+S_i)*omegab_ib;
%q representing rotation between orbital n inertail frame
noidot=-0.5*transpose(eta_oi)*omega_orbit;
etaoidot=0.5*((n_oi*eye(3))+S_oi)*omega_orbit;

long_dot=omega_orbit(2);
lat_dot=sqrt((omega_orbit(1)^2)+(omega_orbit(3)^2));
Alt_dot=0;%const altitude

xdot=[omega_ib_dot;n_o_dot;eta_o_dot;n_i_dot;eta_i_dot;noidot;etaoidot;long_dot;lat_dot;Alt_dot];

end

