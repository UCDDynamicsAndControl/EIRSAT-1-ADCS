function [Bx, By, Bz] = IGRF11(lon, lat, alt, L, tol, Re, COEFS, FRAME)

%__________________________________________________________________________
%
% Magnetic field in ECEF or NED spherical frame. Computed as the spherical
% harmonical approximation of order n and degree m using IGRF-11 Gaussian
% coefficients provided by IAGA. 
% 
% [Bx, By, Bz] = IGRF11(lat, lon, R, N, M, tol, COEFS, FRAME)
%   - [Bx, By, Bz]: Computed magnetic field as a 3x1 vector (T)
%   - lat: latitude (rad)
%   - lon: longitude (rad)
%   - r: distance to the center of the Earth (m)
%   - n: order of the approximation
%   - m: degree of the legendre polynomials used for the approximation
%   - tol: tolerance to avoid singularity %(1e9 in Brathe Thesis)
%   - COEFS: IGRF Coefficients
% -------------------------------------------------------------------------
%   How to load coefficients 
%           COEFS = loadigrfcoefs(time); where 
%           time = datenum(date); where
%           date = datenum('dd-mm-yyyy')
%   IGRF/ must be in Matlab Path
% -------------------------------------------------------------------------
%   - FRAME: String defining the frame in which the magnetic field will be
%   expressed.
%           * 'NED' for North - East - Down
%           * 'ECEF' For Earth centered, earth fixed
%   If not specified, 'ECEF' frame is used by default
% -------------------------------------------------------------------------
%   Frames
%   - Orbit frame: Spanned by the vectors X_o, Y_o, Z,o. Centered at the
%       sattelite's C.O.M. Z_o points towards the center of the earth, X_0
%       is parallel to the orbit agular momentum, Y completes the 
%       riCOEFSt-handed orthonormal frame.
%   - ECEF: Z_e normal to equatorial plane. X_e pointing towards 0
%       longitude, 0 altitude. Y completes the riCOEFSt-handed orthonormal
%       frame.
%   - ECEF spherical: Spanned by the vectors e_lambda, e_theta, e_r.
%       An important consequence is that e_r coincides with - Z_o; thus the
%       transformation between Orbit frame and ECEF Spherical consists of a
%       simple rotation.
%   - NED: Z_n points towards the center of the earth, X_n points towards
%   local north, Y_n points towards local east.
%
%__________________________________________________________________________

% AVOID SINGULARITY
lat = mod(lat,2*pi);
if (lat > pi/2 - tol && lat < pi/2 + tol)
    lat1 = pi/2 + tol;
    warning('latitude %d has been replaced by %d to avoid singularity', lat, lat1); 
    lat = lat1;
elseif (lat > 3*pi/2 - tol && lat < 3*pi/2 + tol)
    lat1 = 3*pi/2 + tol;
    warning('latitude %d has been replaced by %d to avoid singularity', lat, lat1); 
    lat = lat1;
end

%
nmax = sqrt(numel(COEFS) + 1) - 1;
PM = (nmax+1)*(nmax+2)/2;
%

%__CONVERT TO SPHERICAL COORDINATES________________________________________
% Convert latitude, longitude and distance to the center (r)
% to spherical coordinates:
%   - r: distance to the center of the Earth
%   - theta: inclination from z axis
%   - phi: azimuth from x axis.


r = alt+Re;
theta = pi/2 - lat;
phi = lon;
cphi = cos((1:nmax)*phi);
sphi = sin((1:nmax)*phi);
cth = cos(theta);
sth = sin(theta);
%__________________________________________________________________________


% CALCULATION

Br = 0; Btheta = 0; Bphi = 0;
coefindex = 1;
Ar = (Re*1e-3/r);
for Pindex = 2:PM
    if n < m
        m = 0;
        n = n + 1;
        Ar = Ar*(Re*1e-3/r);
    end
    
    % Lagrange Polynomials and derivatives
    [P_, dP_] = legendreRecursive(theta,cth,sth,n,m);
    P(Pindex) = P_;
    dP(Pindex) = dP_;
    
    % Magnetic field 
    if m == 0
        coef = Ar*COEFS(coefindex);
        Br = Br + (n+1)*coef*P(Pindex);
        Btheta = Btheta - coef*dP(Pindex);
        coefindex = coefindex + 1;
    else
        coef = Ar*(COEFS(coefindex)*cphi(m) + COEFS(coefindex+1)*sphi(m));
        Br = Br + (n+1)*coef*P(Pindex);
        Btheta = Btheta - coef*dP(Pindex);
        if sth == 0
            Bphi = Bphi - cth*Ar*(-COEFS(coefindex)*sphi(m) + COEFS(coefindex+1)*cphi(m))*dP(Pindex);
        else
            Bphi = Bphi - 1/sth*Ar*m*(-COEFS(coefindex)*sphi(m) + COEFS(coefindex+1)*cphi(m))*P(Pindex);
        end
        coefindex = coefindex + 2;
    end
    m = m + 1;
end
Btheta = -Btheta;

%Express in different frames
if strcmp(FRAME,'ECEF') || strcmp(FRAME,'ECI')  ||  nargin < 8
    % Convert from spherical to NED
    phi = lon;
    theta = pi/2-lat;
    Bx = (Br*sin(theta) + Btheta*cos(theta))*cos(phi) - Bphi*sin(phi);
    By = (Br*sin(theta) + Btheta*cos(theta))*sin(phi) + Bphi*cos(phi);
    Bz = Br*cos(theta) - Btheta*sin(theta);
    if strcmp(FRAME,'ECI')  ||  nargin < 8
        dcm = dcmeci2ecef('IAU-76/FK5',[2017 8 17 0 0 0]);
        dcm = dcm';
        B = dcm*[Bx;By;Bz];
    end
elseif strcmp(FRAME,'NED');
    % Convert from spherical to NED
    Bx = -Btheta;
    By = Bphi;
    Bz = -Br;
end
