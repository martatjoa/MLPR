function [elv,t] = getElevations(tstart,tspan,dt,file,obslocation)
% Calculates the elevation (angle from the horizon) of a satellite
%
% ELV = GETELEVATIONS(TSTART,TSPAN,DT,FILE,OBS) calculates the elevation
% angles ELV for the satellite defined by the orbital parameters in the
% text file FILE for the times between TSTART and TSTART+TSPAN, in steps of
% DT, as seen by an observer at the location defined by the vector OBS.
%
% The times are determined by a datetime variable TSTART, a duration TSPAN,
% and a duration DT. The filename FILE should be specified as a string
% (including extension). The observer location is a numeric vector with
% three elements: latitude [deg], longitude [deg], and altitude [km].
%
% [ELV,T] = GETELEVATIONS(...) also returns a datetime vector T of the
% times corresponding to the elevations.

% TODO: Make this interface nicer

% Make vector of times
t = (tstart:dt:(tstart+tspan))';
% Read orbital parameters from file
p = readparameters(file);

% Calculate elevations
elv = satellitefix(t,p,obslocation);
% Plot result
figure
plot(t,elv,".-")