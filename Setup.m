%__
dec_year = decyear(2017,25,7);


%__WBC_____________________________________________________________________
s = tf('s');
wtfn = @(w,n) 2/(2 + (2*s*n/w) + (s^2*n^2/w^2));

a = 1;
n = 3;

w = zeros(3);

orb_time = 92.65 * 60;

m11 = 10;
k01 = m11 * (2*pi/3600)^2;
w(1) = sqrt(k01/m11);

m12 = 10;
k02 = m12 * (2*pi/3600)^2;
w(2) = sqrt(k02/m12);

m13 = 10;
k03 = m13 * (2*pi/3600)^2;
w(3) = sqrt(k03/m13);

for i=1:3
    G(i) = wtfn(w(i),1);
    G2np1(i) = wtfn(w(i),n);
    C1(i) = 0.5*(1-a*G(i)^2+(1-a)*G2np1(i));
    C2(i) = a*G(i);
end
%__________________________________________________________________________


%__Magnetorquers___________________________________________________________
%Data taken from 'Design of Attitude Control System of a Double CubeSat 
%(Master Thesis Gaute Brathen). Pg 34. Magnetorquer 1
Magnetorquers = struct;
%Inductance, [H]
Magnetorquers.Lx = 5.6e-3;
Magnetorquers.Ly = 5.6e-3;
Magnetorquers.Lz = 5.6e-3;

% Numer of windings
Magnetorquers.Nx = 221;
Magnetorquers.Ny = 221;
Magnetorquers.Nz = 221;

% Mean area [m^2]
Magnetorquers.Ax = 10395e-4;
Magnetorquers.Ay = 10395e-4;
Magnetorquers.Az = 10395e-4;

% Max current [A]
%   Note this is the maximum current allowed by the conductor, but the true
%   available current from the EPS may be less
Magnetorquers.Ix_max = 113e-3;
Magnetorquers.Iy_max = 113e-3;
Magnetorquers.Iz_max = 113e-3;

% Max corrent available from the EPS as in the mentioned Thesis [A]
Magnetorquers.Ix_maxEPX = 100e-3;
Magnetorquers.Iy_maxEPX = 100e-3;
Magnetorquers.Iz_maxEPX = 100e-3;







