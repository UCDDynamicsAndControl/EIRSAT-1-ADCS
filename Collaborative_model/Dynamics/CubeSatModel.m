function [ xdot ] = CubeSatModel( x,I,T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% state info

% current state vector
omegab_ib=x(1:3);%angular vel of bod frame wrt inert frame
% quaternion re rotation between body frame and inertial frame
q_i=x(4:7);
n_i=q_i(1);
eta_i=q_i(2:4);

S_i=SkewSym(eta_i);

%% Differential Equations of Motion

%derivative of omega of body frame wrt inertial frame
omega_ib_dot=I\(-cross(omegab_ib,I*omegab_ib)+T);%+T_ext);
%q meas wrt inertial frame
n_i_dot=-0.5*transpose(eta_i)*omegab_ib;
eta_i_dot=0.5*((n_i*eye(3))+S_i)*omegab_ib;

xdot=[omega_ib_dot;n_i_dot;eta_i_dot];

end

