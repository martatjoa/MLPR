% A simple test to make sure statellite fix runs.

% Set observer location (latitude, longitude, altitude).
obslocation = [42.3,-71.35,0.1];

% Read orbital parameters from file
p = readparameters("iss.txt");

% Create initial time.
t1 = datetime(2020,10,28);

% Create numeric variable representing days
t2 = 1;

% Save information for satellitefixWrapper
save("satparams","p","obslocation","t1");

% Run Code
result = satelitefixWrapper(t2);
