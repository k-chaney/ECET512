function [ mag, dur ] = rayleighFad( N, fc, fm )
%RAYLEIGHFADING Summary of this function goes here
%   Detailed explanation goes here

% Parameters as defined in Steps 1 and 2 of the Clark and Gans Fading Model
f = linspace(0,fm,N/2+1);
df = 2*fm/(N-1);
T = 1/df;
dur = linspace(0,T,N+1);

%% Generate Random Freqeuncy Spectrum Distribution

% Specify settings for gaussian distribution
mean = pi;
sigma = 1/(2*pi);

% Generate random values and setup the one half of the distributions
% from [0 to N/2] 
dist1 = normrnd(mean,sigma,1,N/2+1)+normrnd(mean,sigma,1,N/2+1).*j;
dist2 = normrnd(mean,sigma,1,N/2+1)+normrnd(mean,sigma,1,N/2+1).*j;

%% Calculate root square of the spectrum

% Calculate root square and replace last entry with linear interpolation
% from the previous two points
rootS = sqrt(1.5./(pi*fm.*sqrt(1-((f+fc)./fm).^2)));
rootS(N/2+1) = rootS(N/2)+(rootS(N/2)-rootS(N/2-1));

%% F

s1 = rootS.*dist1;
s2 = rootS.*dist2;
r1 = real(ifft(ifftshift([fliplr((s1').') s1(2:end)]))).^2;
r2 = real(ifft(ifftshift([fliplr((s2').') s2(2:end)]))).^2;
r = sqrt(r1+r2);
mag = 10*log10(r);

end

