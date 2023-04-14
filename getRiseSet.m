function [trise,tset] = getRiseSet(tstart,tspan,dt,file,obslocation)
% Determines times when a satellite rises and sets over the horizon
%
% [TRISE,TSET] = GETRISESET(TSTART,TSPAN,DT,FILE,OBS) determines the times
% that a satellite, defined by the orbital parameters in the text file
% FILE, rises (TRISE) and sets (TSET), as seen by an observer at the
% location defined by the 3-element vector OBS
% ([latitude,longitude,altitude]), between the times TSTART and
% TSTART+TSPAN, to within a resolution of DT.

% Get elevations and times
[elevation,t] = getElevations(tstart,tspan,dt,file,obslocation);

% Save parameters to a file so they can be read by the wrapper function
% TODO: Can we avoid this???
t1 = t(1);
p = readparameters(file);
save("satparams","p","obslocation","t1")

% Get numeric duration from times
% (need numeric representation for calculation)
tnum = days(t - t1);

% Use the elevations to find when the satellite is rising over horizon
n = length(elevation);

% Step through times
for k = 2:n
    % Look for change of sign (of elevation)
    if (elevation(k)*elevation(k-1) < 0)
        % Find where in that interval the sign change occured
            t0 = fzero(@satellitefixWrapper,tnum(k-1:k));
        if (elevation(k) > 0)
            % Add this to the list of rise times
            trise = [trise;t0];
        else
            % Add to the list of set times
            tset = [tset;t0];
        end
    end
end

% Add rise/set times to plot
hold on
plot(trise,zeros(size(trise)),"go")
plot(tset,zeros(size(tset)),"rx")
hold off
