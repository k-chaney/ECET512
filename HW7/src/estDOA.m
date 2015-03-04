function [P] = estDOA( signals, mobileLocation, antennaLocations, freq, theta_test ) %...
    %mobile_location, cell_center, cell_radius, antennaLocations, ...
    %ref_dist, ref_power, beta, shadow_variance,lambda)


c = 3e8; % speed of light
K = 1; % number of snapshots -- can help with the covariance matrix
nP = 20; % number of sampling periods
Fs = freq*1e1; % sampling frequency
numAntennas = max(size(antennaLocations)); % number of antennas
lambda = c/freq;
length_t = length(theta_test);  % Number of trial angles


lfft=(max(size(signals)))/K;
df=Fs/lfft/1;
F = 0:df:Fs/1-df;

for ih=1:numAntennas
    for iv=1:K
        pos=(iv-1)*lfft+1;
        tmp=signals(ih,pos:pos+lfft-1);
        X(:,ih,iv)=fft(tmp);
    end
end

[mf,mi] = min(abs(F-freq)); % finds the closest fft representation of the signal
f0 = F(mi);


for ih=1:numAntennas
    for iv=1:K
        X0(ih,iv)=X(mi,ih,iv); % readjusts for f0
    end
end

R=X0*X0';

omega = 2*pi*f0;                % Angular frequency of the signal
k=omega/c;                      % wave number


for i=1:numAntennas
a(i,:) = exp(-j.*k.*((antennaLocations(1,i)-real(mobileLocation)).*cos(theta_test) ...
    +(antennaLocations(2,i)*imag(mobileLocation)).*sin(theta_test)))';
end


% Calculation the power at different trial angles
for i=1:length_t
    P(i)=a(:,i)'*R*a(:,i)/(a(:,i)'*a(:,i));
end
P=real(P);

% signal_strength, signal_phase, connected_index