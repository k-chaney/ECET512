% Set up parameters for Matlab movie
clear, clc, close all;

radius = 1;
lambda = 1;
E0 = 1;

% sets up the sphere that we will be doing the calculations based off of
[X,Y,Z] = sphere(51);

% scales to the desired radius
X=X*radius;
Y=Y*radius;
Z=Z*radius;

% converts cartesian to polar
[THETA, PHI, R] = cart2sph(X, Y, Z);

signalStrength = (farfield( THETA, PHI, R, lambda, E0));
figure(1)
surf(X, Y, Z, signalStrength);%,'EdgeColor','none')
figure(2)
[X1,Y1,Z1] = sph2cart(THETA, PHI, (signalStrength));
surf(X1, Y1, Z1, signalStrength);%,'EdgeColor','none')

theta_2 = linspace(-2*pi,2*pi,100);
phi_2 = linspace(-2*pi,2*pi,100);

figure(3)
polar(theta_2,farfield(theta_2, 0, radius, lambda, E0));
figure(4)
polar(phi_2,farfield(0, phi_2, radius, lambda, E0));