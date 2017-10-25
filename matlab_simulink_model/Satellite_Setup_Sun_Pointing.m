%% Add folders to path
addpath('Environment/IGRF','Actuators','Control','Disturbances','Dynamics','Graphics');

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

%% initial state 

lat_init=0;
long_init=0;

qo_i_init=angle2quat((0)*pi/180,(90)*pi/180,(90)*pi/180,'XYZ');

% %initially alligned with inertial frame
qb_o_init=angle2quat(0,90*pi/180,90*pi/180,'XYZ');
qb_i_init=angle2quat(0,0,0,'XYZ');


 quat_error=angle2quat(0*pi/180,0*pi/180,0*pi/180,'XYZ');%initial attitude error
qb_o_init=quatmultiply(quatconj(quat_error),qb_o_init);
qb_i_init=quatmultiply(quatconj(quat_error),qb_i_init);

%init ang vel of body frame wrt inertial frame
wb_bi_init=[0;0;0];%match vel with inert frm

x_0=[transpose(wb_bi_init),qb_i_init];%inital state vector of satelite 
x_orbit_init=[long_init,lat_init,altitude,qb_o_init,qo_i_init];%initial orbit parameters
