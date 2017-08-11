%__________________________________________________________________________
%
% Script to test the discrete Low-Pass filter implemented 
% in discreteLPfilter.m
%
%__________________________________________________________________________

% Frequencies
sampl_freq = 1;
sign_freq = 1/(92*60); %Order of magnitude the inverse of orbital time
noise_freq = sign_freq*10; 
cutoff_freq = 0.8*sign_freq + 0.2*noise_freq;
%
% What noise do we expect from the magnetometers?
%

sampl_T = 1/sampl_freq;
t = [0:sampl_T:3*92*60];
sign_omega = 2*pi*sign_freq;
noise_omega = 2*pi*noise_freq;

signal = 3*cos(sign_omega*t) + sin(3*sign_omega*t);

noise = 3*cos(noise_omega*t) + 5*sin(2*noise_omega*t);
noisy_signal = noise + signal;


filtered_signal = zeros(1,length(t));
filtered_signal(1) = signal(1);

for i = 2:length(t);
    filtered_signal(i) = discreteLPfilter(filtered_signal(i-1), ...
        noisy_signal(i), cutoff_freq, sampl_freq);
end;

%close all;
figure;
hold on;
    plot(t,noisy_signal,'y');
    plot(t,signal,'b');
    plot(t,filtered_signal,'r','LineWidth',2);
hold off;
xlabel('time (s)');
legend('Signal with noise','Signal w.o. noise','Filtered signal');