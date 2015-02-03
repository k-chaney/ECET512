% Set up parameters for Matlab movie
clear, clc, close all;

radius = 1;

% sets up the sphere that we will be doing the calculations based off of
[X,Y,Z] = sphere(50);
C = zeros(size(X));

% scales to the desired radius
X=X*radius;
Y=Y*radius;
Z=Z*radius;




surf(X,Y,Z,C)