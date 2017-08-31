%% Add folders to path
% addpath('Actuators','Control','Disturbances','Dynamics','Graphics');

%% Define Satellite properties 
mass=2.6;
lx=0.10;ly=0.10;lz=0.20;
Ixx=(1/12)*mass*((ly^2)+(lz^2));
Iyy=(1/12)*mass*((lx^2+lz^2));
Izz=(1/12)*mass*((lx^2+ly^2));
I=diag([Ixx;Iyy;Izz]);

%% IGRF Setup
load('IGRF11notmorm.mat'); % Load the structure containing the data for IGRF
[igrf_G,igrf_H] = loadIGRFCoeffs(IGRF11notnorm); % Normalize the coefficients and store g_n^m and h_n^m in two matrices
igrf_L = 10; % Upper limit for n in the approximation. for IRGF, it must be less or equal than 13
igrf_tol = 1e-9; % Tolerance to avoid singularity at latitute = +- pi/2

%% Aerodynamic drag propierties
aerodrag_c_p = 0.02*[1;1;1]; % Vector C.O.Mass - C.O.Pressure. Expressed in body frame
aerodrag_A_d = 0.2*0.1*sqrt(2); % Aerodynamic area.

%% Define orbit properties
omega_orbit=[0;-7.67/(401.1+6371);0];% Ang vel of orbit frame wrt inertial
% frame. give the same orbit period as ISS, buit is orbitng about equator
altitude=405000;%similar altitude as ISS;