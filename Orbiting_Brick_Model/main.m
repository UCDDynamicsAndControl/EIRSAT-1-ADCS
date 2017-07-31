clear all; close all; clc;
%Run Setup
CubeQuat_setup;

%Run simulation
sim('CubeQuat.slx');


figure;
subplot(3,1,1)
plot(time,omega_oi);
xlabel('time (s)')
ylabel('\omega_oi (rad/s)')

subplot(3,1,2)
plot(time,Euler_angl);
xlabel('time (s)')
ylabel('Euler angles (rad)')

subplot(3,1,3)
plot(time,torques);
xlabel('time (s)')
ylabel('Torques (Nm)')