function Tb = gravityGradient(qb_o,omega_orbit)

%__________________________________________________________________________
%
%Computes the gravity gradient torque, according to 'Attitude Control System
% of a Double CubeSat - Gaute Brathen'
%
% -------------------------------------------------------------------------
% Inputs
% - qb_o: quaternion between body and orbit frame
% - omega_orbit: orbital angular velocity wrt inertial frame, expressed in
%   orbital frame. 
%   eg. for an polar orbit, it would take the form [0, -w_io, o]
%
%__________________________________________________________________________


%Extract the quaternion from the state vector
n=qb_o(1);
eps=qb_o(2:4);

%Skew-simmetric associated with the quaternion's vector part
S = SkewSym(eps);

%Rotation matrices between orbit and body frame
Ro_b = eye(3) + (2*n*S) + (2*(S^2)); %Transforms from the body frame to the orbital frame
Rb_o = transpose(Ro_b); %Transforms from the orbital frame to the body frame

c_3=Rb_o(:,3); %3rd Column

Tb=3*(omega_orbit(2)^2)*SkewSym(c_3)*eye(3)*c_3;

return;
