%Graphics
figure;
subplot(4,1,1)
plot(time,omega_oi);
xlabel('time (s)')
ylabel('\omega_oi (rad/s)')

subplot(4,1,2)
plot(time,Euler_angl);
xlabel('time (s)')
ylabel('Euler angles (rad)')

subplot(4,1,3)
plot(time,torques);
xlabel('time (s)')
ylabel('Torques (Nm)')

subplot(4,1,4)
plot(time,x_coupl_fdbck);
xlabel('time (s)')
ylabel('Cross-coupling (Nm)')