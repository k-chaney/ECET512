function [signals] = signalSimulation(  ...
    mobileLocation, antennaLocations, freq)


c = 3e8; % speed of light
K = 1; % number of snapshots -- can help with the covariance matrix
nP = 20; % number of sampling periods
Fs = freq*1e1; % sampling frequency
numAntennas = max(size(antennaLocations)); % number of antennas
lambda = c/freq;


omega = 2*pi*(3e8/lambda);
k=omega/3e8;

theta = atan2( imag(mobileLocation-antennaLocations(2)), ...
    real(mobileLocation-antennaLocations(1)));

a = exp(-j.*k.*((antennaLocations(1,:)-real(mobileLocation)).*cos(theta) ...
    +(antennaLocations(2,:)*imag(mobileLocation)).*sin(theta)))'; % delays for each antennna

times = [0:1/Fs:nP/freq-1/Fs]; % time snapshot consisting of predefined number of periods
signals = zeros(numAntennas,length(times));
for i=1:numAntennas
    signals(i,:) = exp(j*omega*times)*a(i); % standard sinusoidal wave could be modified
end