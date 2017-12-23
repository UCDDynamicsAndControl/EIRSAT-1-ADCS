
%%
% This code generates several folders, containing:
% - a .txt file, specifing the most important aspects of the simulation.
% - a set of graphics:
%       - Angular Velocity wrt inertial frm
%       - Quaternion btwn Sat & Inertial frm
%       - Longitude, Latitude
%       - Altitude
%       - Quaternion btwn Sat & Orbit frm
%       - Quaternion btwn orb frm & inertial
%       - Control Torque
%       - B (Magnetic field)
%       - Actuator Torque
%       - Reference quaternion
%       - Current in the coils
%       - Euler Angles btwn Sat & Inertial frm
%       - Euler Angles btwn Sat & Orbit frm
%       - Euler Angles btwn orb frm & inertial
%
% - (?) A .tex file, Containing
%       - All the figures
%       - A set of labels and references to these
%       - The text inside the .txt file
%
% - A .mat file, with the data generated during the simulation
%
% -------------------------------------------------------------------------
% This code is a modification of 'Control_mission_def.m'. It will run the
% simulation for several values of:
%   - K 
%   - w
%   - Initial conditions 
%
% Notes: 
%   - all simulations use WBC
%   - all simulations use 3 - axis magnetorquers
%   - all simulations use the same sattelite propierties, defined in
%       'Satellite_Setup.m'
%   - all actuators have the same A*m^2 propierties
%   - all simulations try to do Sun (inertial) Facing
%   - every simulation uses same solver setup

% _________________________________________________________________________

% PREAMBLE (This code runs only once)
% Solver setup
T_orbit = 5559;
T_stop = 10*T_orbit;
Rel_tol = 1e-3;

% Add everything inside 'collaborative_model' to Matlab path
addpath(genpath('collaborative_model')); 
Satellite_Setup.m %run setup file

% Plots
indices_array = [3 4 2 1 4 4 3 3 3 4 3 3 3 3]; 
x_labels_array = ['ang. vel (rad/s)';
          'q';
          'angle (rad)';
          'Altitude (m)';
          'q';
          'q';
          'T (Nm)';
          'B (T)';
          'T (Nm)';
          'q';
          'i (A)';
          'angle (rad)';
          'angle (rad)';
          'angle (rad)'];
      
titles_array = ['Angular velocity';
          'qb_i';
          'Longitude, Latitude';
          'Altitude';
          'qb_o';
          'qo_i';
          'Control Torque';
          'Simulated magnetic field';
          'Actuator torque';
          'q_ref';
          'Current';
          'Euler angles Sattelite - Inertial r.f.';
          'Euler angles Sattelite - Orbital r.f.';
          'Euler angles Orbital r.f. - Inertial r.f.'];
      
% These are the values that the three 'for' loops are going to go through
m = 0.0108;
k_array = [1e-9 1e-8; 5e-8 1e-7; 5e-7 1e-6];
w_array = [sqrt(k/m); sqrt(2*k/m); sqrt(3*k/m); sqrt(4*k/m)];
ic_array = [0.1,0,0; 0.5,0,0; 0.1,0.1,0; 0.1,0.1,0.1; 0.05,0.05,0.05; 0.1,0.1,0.1]; %Euler angles through the rows

% BEGINNING OF LOOP
for i_k = 1:length(k_array)
for i_w = 1:length(w_array)
for i_ic = 1:length(ic_array)

sim_data = sim('EIRSAT_ADCS'); % Run simulink model
for i_plot = 1:13
    j_plot = 1;
    k_plot = indices_array(i_plot);
    close all
    figure;
    plot(DATA(j_plot:j_plot+k_plot-1),time;
    xlabel(x_labels_array(i_plot));
    title(titles_array(i_plot));
    y_label('time (number of orbits)');
end  
% Save simout to a .mat file
'DATA_w_time' = [DATA,TIME];
save('data.mat','DATA');
end
end
end
%END OF LOOP

