function LST = siderealtime(t,lon)
% Determines local sidereal time
%
% LST = SIDEREALTIME(T,LON) calculates the sidereal time given the (UTC)
% time T [datetime] and the longitudinal position LON [in degrees].

% J2000 (shifted Julian date)
D = days(t - datetime(2000,1,1,12,0,0));
% Greenwich mean sidereal time
GMST = mod(18.697374558 + 24.06570982441908*D,24);
% Adjust for local longitude
LST = mod(GMST + 1.0027379*lon/15,24);