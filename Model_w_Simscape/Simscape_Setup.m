%--20.7.2017-------------------------------------------------------------

% Next Steps: -Inclde OFF frame
%             -Detumbling alborithm. Only velocities to zero. Do not care
%             about position
%             -Implement coils 
%
% Do not forget to reinitialize from source on Model explorer

%------------------------------------------------------------------------

% Model-Wide Parameters
G = 6.67e-11; % Universal gravitational constant

% Earth Parameters
% Scaling = 2e4;
% Earth.M = 1.99e30;
Earth.M = 5.972e24;
Earth.w = 7.2921e-5 * (180/pi);
Earth.R = 5000e3;
Earth.RGB = [0.1 0.5 0.7]; % [0.85 0.45 0];

%---------------------------------------------
% EIRSAT1 Parameters
% EIRSAT1.M = 3.30e23;
EIRSAT1.M = 20;

EIRSAT1.COM = [0 0 0]; %Position of COM relative to BFF frame (m)
EIRSAT1.MomI = [10 10 10]; %Moments of inertia in the form [Ixx Iyy Izz] (Kg m2)
EIRSAT1.ProdI = [0 0 0]; %Procucts of inertia
EIRSAT1.R = Earth.R/10;
EIRSAT1.RGB = [0.8 0.8 0.8];
%EIRSAT1.Px = 6.98e10;
EIRSAT1.Px = 6371e3 + 400e3; 
EIRSAT1.Py = 0;
EIRSAT1.Vx = 0;
%EIRSAT1.Vy = 3.89e4;
EIRSAT1.Vy = 7.664e3;
