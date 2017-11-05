%PD which is ok for zenith pointing. Use quaternion between body and orbit
%frame and the derivative of this as the input to the PD controller. If
%initial angular velocity is too high, this controller will draw more than
%the 500mA current limit.

%kp=2.5000e-10;
kp=1.6e-7;
kd=2e-4;
CtrlType=3;