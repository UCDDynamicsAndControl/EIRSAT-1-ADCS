%Computes the aerodynamic drag. 
%According to 'Attitude Control System of a Double CubeSat - Gaute Brathen
% sec 3.6.2

%Inputs:

% - x: state vector, from which the quaternion will be extracted 
%       x = [omega(3x1);q(4x1)]
%       q = [eta;epsilon] = [x(4),x(5:7)]
% - omega_orbit: orbital angular velocity wrt inertial frame, expressed in
%   orbital frame. 
%   eg. for an polar orbit, it would take the form [0, -w_io, o]
% - Data = [rho_a, A_p, 

%       - rho_a: atmospheric density (Kg/m^3)
%       - A_p: aerodynamic area. Set as constant, but could be
%        defined as a function of attitude.
%       - V_o_b: Unity vector of the local atmosphere velocity vector.
%        For convenience, it is usually expresed in terms of the orbital
%        frame (V_o_r), because it is parallel to the x plane; so
%        (as the torque output is expresed i.t.o. the body frame), we'll
%        need to transform it (V_b_r) using the rotation matrix Rb_o
%       - vel: magnitude of the local atmosfhere velocity
%       "Harcoded" as orbital velocity x radius
%       - J: Inertia tensor with origin the center of pressure, calculated
%       from Steiner's Theorem

%Extract the quaternion and omega from the state vector
omega = x(1:3);
q=x(4:7);
n=q(1);
eps=q(2:4);

S = SkewSym(eps); %Squew-Sym matrix associated with vector part of quaternion

%Rotation matrices between orbit and body frame
Ro_b = eye(3) + (2*n*S) + (2*(S^2)); %Transforms from the body frame to the orbital frame
Rb_o = transpose(Ro_b); %Transforms from the orbital frame to the body frame

omega_b_ob=omega-(Rb_o*omega_orbit);

rho_a = 4.89e-13; %Atmospheric density at LEO (Better 
c_p = 0.02*[1;1;1]; %(!!!) HARDCODE Vector C.O.Mass - C.O.Pressure i.t.o. body frame
c_pSk = SkewSym(c_p); % its Skew-Sym matrix
V_o_r = [-1;0;0]; % Unity vector in the direction of the 
%                        local atmospheric velocity i.t.o. orbital frame                       frame
V_b_r = Rb_o * V_o_r; % ... in terms of body frame
VrSk = SkewSym(V_b_r); % its Skew-Sym matrix
vel = 7.664e3; %(!!!) HARDCODE magnitude of the local atmosfhere velocity
a = c_p(1)^2; b = c_p(2)^2; c = c_p(3)^2;
J = I + mass * [b+c c b; c a+c a; b a a+b] %Inertia with origin the center of pressure. Steiner theorem
A_d = 0.2*0.1*sqrt(2) %(!!!) HARDCODE Aerodynamic area. Wrost case scenario

Tb_drag = rho_a * vel * (vel*A_d*c_pSk*V_b_r - (I + VrSk*J) * omega_b_ob);

return;
