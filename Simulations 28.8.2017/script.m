
%%
% This code generates several folders, containing:
% - (?) a .txt file, specifing the most important aspects of the simulation.
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
%   - k 
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
T_stop = 2*T_orbit;
Rel_tol = 1e-3;

% Add everything inside 'collaborative_model' to Matlab path
addpath(genpath('collaborative_model')); 
Satellite_Setup % Set satellite characteristics

% Plots
indices_array = [3 4 2 1 4 4 3 3 3 4 3 3 3 3]; 
y_labels_array = {'ang. vel (rad/s)';
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
          'angle (rad)'};
       
 titles_array = {'Angular velocity';
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
           'Euler angles Orbital r.f. - Inertial r.f.'};

m = 0.0108;
% BEGINNING OF LOOP
INDEX = 1;
k_array = [1e-8; 5e-8; 1e-7; 5e-7; 1e-6];
for i_k = 1:length(k_array)
k = k_array(i_k);
w_array = [sqrt(k/m); sqrt(2*k/m); sqrt(3*k/m); sqrt(4*k/m)];
for i_w = 1:length(w_array)
w = w_array(i_w);
ic_array = [0.1,0,0; 0.5,0,0; 0.1,0.1,0; 0.1,0.1,0.1; 0.05,0.05,0.05; 1,1,1]; %Euler angles through the rows
for i_ic = 1:length(ic_array)
folder_name = ['28_8_2017_',int2str(INDEX)];
mkdir(folder_name);
ic = ic_array(i_ic,:);
qb_i_init=angle2quat(ic(1),ic(2),ic(3),'XYZ');
setup % Set all the parameters that are not in the loop
sim('EIRSAT_ADCS'); % Run simulink model
TIME_n_orb = TIME/T_orbit;
j_plot = 1;
for i_plot = 1:13 %Plots
    tic
    k_plot = indices_array(i_plot);
    close all
    figure;
    hold on
    plot(TIME_n_orb,DATA(:,j_plot:j_plot+k_plot-1)); % Make plots
    %plot([0,T_stop],[0,0],'b--');
    ylabel(y_labels_array{i_plot}); % x axis label
    xlabel('time (number of orbits)'); % y axis label
    title_name = titles_array{i_plot};
    title(title_name); % title
    img_path_name = ['/',folder_name,'/',title_name,'.png'];
    saveas(figure(1),[pwd img_path_name]);
    j_plot = j_plot + k_plot;
    hold off
end  
plot(TIME_n_orb,T_dist);
ylabel('T (Nm)');
xlabel('time (number of orbits)');
title('Disturbances');
img_path_name = ['/',folder_name,'/','Disturbances','.png'];
saveas(figure(1),[pwd img_path_name]);
% Write .txt file with some info
file_name = [folder_name,'_info.txt'];
out = fullfile(folder_name,file_name);
fid = fopen( out, 'wt' );
k = k*1e7; 
fprintf( fid, ['k = %fe-7\n','w = %f\n', 'Initial Conditions = [%f,%f,%f]\n', 'ran in %f secs'],k, w, ic(1),ic(2),ic(3),toc);
fclose(fid);
if fid ~= -1
    warning('Error writting .txt file in simulation number %i', INDEX);
end

% Save data to a .mat file
DATA_W_TIME = [DATA,TIME];
file_name = [folder_name,'.mat'];
out = fullfile(folder_name,file_name);
save(out,'DATA_W_TIME')

fprintf('%f simulations out of 144 completed\n', INDEX)
INDEX = INDEX+1;
end
end
end
%END OF LOOP

