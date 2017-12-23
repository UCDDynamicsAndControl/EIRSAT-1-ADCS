function xdot = roationalDynamics(x,M,I,omega_orbit)
%Model of orbiting cube sat dynamics
%   A model a cube sat orbing the earth. The output, xdot, is the time
%   derivative of the state vector x. x=[omega,q]. where omega is the
%   angular velocity of the body fixed frame relative to the inertial frame
%   at the centre of the earth. q is a quaternion which represents the
%   rotation between the body fixed frame and the orbital frame. 

% x=[omega,q];
% xdot = zeros(7,1);

%Definition of the state vector
omega=x(1:3);
q=x(4:7);
n=q(1);
eta=q(2:4);

S=SkewSym(eta);

%Rotation matrices between orbital and fixed frame, in terms of the
%quaternion
Ro_b=eye(3)+(2*n*S)+(2*(S^2)); %Transforms from the body frame to the orbital frame
Rb_o=transpose(Ro_b); %Transforms from the orbital frame to the body frame

c_3=Rb_o(:,3); %3rd Column (See Design of Attitude Control System of a Double CubeSat - Gaute Brathen)

omega_ob=omega-(Rb_o*omega_orbit); 

omega_dot=I\((-cross(omega,I*omega))+M);
ndot=-0.5*transpose(eta)*omega_ob;
etadot=0.5*((n*eye(3))+S)*omega_ob;

xdot=[omega_dot;ndot;etadot];

return;
