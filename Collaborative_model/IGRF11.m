function [Bx, By, Bz] = IGRF11(lat, lon, alt, n, m, tol, Param, FRAME)

%__________________________________________________________________________
%
% Magnetic field in ECEF or NED spherical frame. Computed as the spherical
% harmonical approximation of order n and degree m using IGRF-11 Gaussian
% coefficients provided by IAGA. 
% 
% [Bx, By, Bz] = IGRF11(lat, lon, R, N, M, tol, Param)
%   - [Bx, By, Bz]: Computed magnetic field as a 3x1 vector (T)
%   - lat: latitude (rad)
%   - lon: longitude (rad)
%   - r: distance to the center of the Earth (m)
%   - n: order of the approximation
%   - m: degree of the legendre polynomials used for the approximation
%   - tol: tolerance to avoid singularity %(1e9 in Brathe Thesis)
%   - Param: Structure containing essential data. 
%           To be extracted:
%           * Param.Re: Mean radius of the earth
%           * Param.IGRF_coefs: IGRF Coefficients
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
Pmax = (nmax+1)*(nmax+2)/2;
%


%__CONVERT TO SPHERICAL COORDINATES________________________________________
% Convert latitude, longitude and distance to the center (r)
% to spherical coordinates:
%   - r: distance to the center of the Earth
%   - theta: inclination from z axis
%   - phi: azimuth from x axis.

% Load parameters from Param structure
Re = Param.Re;
COEFS = Param.IGRF_coefs

r = alt+Re;
theta = pi/2 - lat;
phi = lon;
cphi = cos((1:nmax)*phi);
sphi = sin((1:nmax)*phi);
cth = cos(theta);
sth = sin(theta);
%__________________________________________________________________________


% CALCULATION
Br = 0; Bt = 0; Bp = 0;
P = zeros(1, Pmax);  P(1) = 1;  P(3) = sth;
dP = zeros(1, Pmax); dP(1) = 0; dP(3) = cth;
m = 1; n = 0; coefindex = 1;
a_r = (Re*1e-3/r)^2;

for Pindex = 2:Pmax
    if n < m
        m = 0;
        n = n + 1;
        a_r = a_r*(Re*1e-3/r);
    end
    
    % Lagrange Polynomials and derivatives
    if m < n && Pindex ~= 3
        last1n = Pindex - n;
        last2n = Pindex - 2*n + 1;
        P(Pindex) = (2*n - 1)/sqrt(n^2 - m^2)*cth*P(last1n) - sqrt(((n-1)^2 - m^2) / (n^2 - m^2)) * P(last2n);
        dP(Pindex) = (2*n - 1)/sqrt(n^2 - m^2)*(cth*dP(last1n) - sth*P(last1n)) - sqrt(((n-1)^2 - m^2) / (n^2 - m^2)) * dP(last2n);
    elseif Pindex ~= 3
        lastn = Pindex - n - 1;
        P(Pindex) = sqrt(1 - 1/(2*m))*sth*P(lastn);
        dP(Pindex) = sqrt(1 - 1/(2*m))*(sth*dP(lastn) + cth*P(lastn));
    end
    
    % Magnetic field 
    if m == 0
        coef = a_r*COEFS(coefindex);
        Br = Br + (n+1)*coef*P(Pindex);
        Bt = Bt - coef*dP(Pindex);
        coefindex = coefindex + 1;
    else
        coef = a_r*(COEFS(coefindex)*cphi(m) + COEFS(coefindex+1)*sphi(m));
        Br = Br + (n+1)*coef*P(Pindex);
        Bt = Bt - coef*dP(Pindex);
        if sth == 0
            Bp = Bp - cth*a_r*(-COEFS(coefindex)*sphi(m) + COEFS(coefindex+1)*cphi(m))*dP(Pindex);
        else
            Bp = Bp - 1/sth*a_r*m*(-COEFS(coefindex)*sphi(m) + COEFS(coefindex+1)*cphi(m))*P(Pindex);
        end
        coefindex = coefindex + 2;
    end
    m = m + 1;
end
Bt = -Bt;


%Express in different frames
if strcmp(FRAME,'ECEF') || nargin<8
    % Convert from spherical to NED
    phi = lon;
    theta = pi/2-lat;
    Bx = (Br*sin(theta) + Bt*cos(theta))*cos(phi) - Bp*sin(phi);
    By = (Br*sin(theta) + Bt*cos(theta))*sin(phi) + Bp*cos(phi);
    Bz = Br*cos(theta) - Bt*sin(theta);
elseif strcmp(FRAME,'NED'); % We cannot compare strings directly
    % Convert from spherical to NED
    Bx = -Bt;
    By = Bp;
    Bz = -Br;
else
