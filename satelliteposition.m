function [lat,lon,r] = satelliteposition(t,satparams)
% Determines (ECF) position of a satellite at a given time
%
% [LAT,LON] = SATELLITEPOSITION(T,PARAMS) calculates the latitude (LAT) and
% longitude (LON), in Earth-centered fixed coordinates, of a satellite
% defined by the orbital parameters in the structure PARAMS for each time
% in the datetime array T.
%
% [LAT,LON,RADIUS] = SATELLITEPOSITION(...) also returns the satellite's
% distance, in km, from the center of the Earth.

% Extract parameters
inc = satparams.inclination;  % Inclination [deg]
e = satparams.eccentricity;   % Eccentricity []
n = satparams.motion;         % Mean Motion [rev/day]

% Semi-major axis
a = (2.975541313977700e+015/(2*pi*n)^2)^(1/3); % Constant is G*M_Earth

% Constant for converting between degrees and radians
rd = 180/pi;

% Calculate time since epoch
dt = days(t - satparams.epoch);
% Number of rotations since epoch time
ndt = n*dt;
% Current mean anomaly (Mt0 + fractional part of ndt)
M = mod(satparams.anomaly + 360*(ndt - floor(ndt)),360)/rd;
% Solve Kepler's equation to get eccentric anomaly
E = M;
f = e*sin(E) + M;
while norm(E-f) > 1e-6
    E = f;
    f = e*sin(E) + M;
end
% Calculate true anomaly
nu = 2*rd*atan2(sqrt((1+e)/(1-e))*sin(E/2),cos(E/2));

% Account for precession of orbit (RAAN and Arg of Perigee)
[aWt,wt] = precession(a,e,inc,ndt,satparams.RAAN,satparams.argPerigee);
% Argument of Latitude
mu = mod(wt + nu,360);
% Difference in RA between satellite's geocentric position and RAAN
Da = acosd(cosd(mu) ./ sqrt(1-sind(inc)^2*sind(mu).^2));
idx = ((inc < 90) & (mu > 180)) | ((90 < inc) & (180 > mu));
Da(idx) = 360 - Da(idx);

% Geocentric coordinates (RA and DEC)
ag = mod(aWt + Da,360);
dg = sign(sind(mu)).*acosd(cosd(mu)./cosd(Da));

% Radial distance
r = a*(1-e^2)./(1+e*cosd(nu));

lat = dg;
% Get longitude by shifting by Greenwich ST (then wrap to [-180 180])
lon = mod(ag - 15*siderealtime(t,0) + 180,360) - 180;
