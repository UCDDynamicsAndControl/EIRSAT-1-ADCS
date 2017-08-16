%% Define Satellite properties 
mass=2.6;
lx=0.10;ly=0.10;lz=0.20;
Ixx=(1/12)*mass*((ly^2)+(lz^2));
Iyy=(1/12)*mass*((lx^2+lz^2));
Izz=(1/12)*mass*((lx^2+ly^2));
I=diag([Ixx;Iyy;Izz]);

%IGRF11 Setup


%% Define orbit properties

omega_orbit=[0;-7.67/(401.1+6371);0];% Ang vel of orbit frame wrt inertial
% frame. give the same orbit period as ISS, buit is orbitng about equator
altitude=405000;%similar altitude as ISS;

%% initial state 

wb_bi_init=[0,0,0];%init ang vel of body frame wrt inertial frame
qb_o_init=angle2quat(0,0,0,'XYZ');
qb_i_init=angle2quat(0,0,0,'XYZ');
qo_i_init=angle2quat(0,0,0,'XYZ');
lat_init=0;
long_init=0;

x_0=transpose([wb_bi_init,qb_i_init]);%inital state vector of satelite 
x_orbit_init=[long_init,lat_init,altitude,qb_o_init,qo_i_init];%initial orbit parameters
