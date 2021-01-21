
% Load CWA file re-sampled at 100Hz
fprintf('Loading and resampling data...\n');
Fs = 100;
data = resampleCWA('Data/1B.cwa', Fs);


% Read data
data = audioread('Data/1B.wav');
data = dataB(:,1:3) * 8;
