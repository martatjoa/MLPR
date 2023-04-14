function elv = satelitefixWrapper(tnum)
% Determines the elevation of a satellite at given times.
%
% EL = SATELITEFIXWRAPPER(TNUM) calculates the elevation (EL), in
% degrees from horizontal of a satellite defined by the data saved in 
% SATPARAMS.MAT for each time in the double array TNUM, measured in days 
% from the initial time.

data = load("satparams"); % FIXME: Need to ensure all files that create
                          % satparams.mat save the correct information into it
t = data.t1 + days(tnum);
elv = satellitefix(t,data.p,data.obslocation);
