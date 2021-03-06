function Beta = IGRF(lon, lat, alt, L, tol, G_coefs, H_coefs, LST)

%__________________________________________________________________________
%
% Magnetic field in inertial reference frame. Computed as the spherical
% harmonical approximation of order using IGRF Gaussian coefficients 
% provided by IAGA. 
% 
% [Bx, By, Bz] = IGRF(lat, lon, R, N, M, tol, COEFS, FRAME)
%   - [Bx, By, Bz]: Computed magnetic field as a 3x1 vector (T)
%   - lat: latitude (rad)
%   - lon: longitude (rad)
%   - alt: altitude (m)
%   - L: Upper limit for n in the spherical harmonic approximation
%   - tol: tolerance to avoid singularity at lat = +- pi/2 %(1e9 in Brathe Thesis)
%   - G_COEFS: Schmidt quasi-normalized Gaussian coefficients in matrix
%       form. n goes down the rows, m goes though the columns. 
%       Mind the offset in m: g_n^m = G_COEFS(n,m+1)
%   - H_COEFS: Idem
%   - LST: Local sidereal time of the object
%__________________________________________________________________________

%% AVOID SINGULARITY
lat = mod(lat,2*pi); % Ensures 0 <= lat <= 2*pi
if (lat > pi/2 - tol && lat < pi/2 + tol)
    lat1 = pi/2 + tol;
    warning('latitude %d has been replaced by %d to avoid singularity', lat, lat1); 
    lat = lat1;
elseif (lat > 3*pi/2 - tol && lat < 3*pi/2 + tol)
    lat1 = 3*pi/2 + tol;
    warning('latitude %d has been replaced by %d to avoid singularity', lat, lat1); 
    lat = lat1;
end

%% 
% Convert LLA to spherical
%   - r: distance to the center of the Earth
%   - theta: inclination from z axis (co-latitude)
%   - phi: azimuth from x axis.

Re = 6371e3; % Mean Radius of the Earth, in meters
r = alt + Re;
theta = pi/2 - lat;
phi = lon;
sth = sin(theta);

%% CALCULATION
Br=0; Btheta=0; Bphi=0;
for n = 1:L
    A = (Re/r)^(n+2);
    for m = 0:n;
        cmphi = cos(m*phi); smphi = sin(m*phi); %They are used several times. Precalculate them
        % Calculate Gauss normalized Legendre polynomials and derivatives
        % (!!!) This polynomials are not Gauss Quasi-normalized, as required.
        % The normalization is made in the g and h coefficients, they must
        % be provided already Gauss Quasi-normalized
        P = GaussLegRecursive(theta,n,m);
        dP = dGaussLegRecursive(theta,n,m);
        g = G_coefs(n,m+1); h = H_coefs(n,m+1); % Gaussian coefficients
        % Calculate magnetic field components.
        Br = Br + A*(n+1)*((g*cmphi + h*smphi)*P);
        Btheta = Btheta - A*((g*cmphi + h*smphi)*dP);
        Bphi = Bphi -(1/sth)*A*(m*(-g*smphi + h*cmphi)*P);
    end
end
Br = Br *1e-9; Btheta = Btheta *1e-9;  Bphi = Bphi *1e-9; % Convert from nT to T


%% FRAME TRANSFORMATION
[Bx,By,Bz] = msph2inert(Br,Btheta,Bphi,lat,LST);
Beta = [Bx, By, Bz];

function [Bx,By,Bz] = msph2inert(Br,Btheta,Bphi,lat,LST)
% Inputs ------------------------------------------------------------------
% Br B in radial direction
% Bt B in theta direction
% Bp B in phi direction 
% LST Local sidereal time of location (rad)
% lat Latitude (rad)
% Outputs -----------------------------------------------------------------
% Bx B in x-direction | Magnetic field strength (B)
% By B in y-direction | in geocentric inertial coordinates
% Bz B in z-direction |
% Coordinate transformation -----------------------------------------------
Bx = (Br*cos(lat)+Btheta*sin(lat))*cos(LST) - Bphi*sin(LST);
By = (Br*cos(lat)+Btheta*sin(lat))*sin(LST) + Bphi*cos(LST);
Bz = (Br*sin(lat)+Btheta*cos(lat));

return;


