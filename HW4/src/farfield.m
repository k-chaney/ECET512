function [ U, Etheta, Ephi ] = farfield( theta, phi, r, lambda, E0)
% Solves the far field equations for given arguments
%
% returns
%     -- U  --  the radiation intensity
%     -- Etheta -- 
%     -- Ephi --

k = 2.*pi./lambda;
A = 0.5.*lambda;
B = 0.25.*lambda;

vx = A/lambda.*sin(theta).*cos(phi);
vy = B/lambda.*sin(theta).*sin(phi);

F0 = 2/pi.*sin(pi.*vy)./(vy);
F0( isnan(F0) ) = 2;

F1 = 4./pi.*cos(pi.*vx)./(1-4.*vx.^2);

Etheta = j.*exp(-j.*k.*r)./(lambda.*r).*E0.*A.*B./4.*(1+cos(theta))./2.*sin(phi).* ...
    F0.*F1;
Ephi = j.*exp(-j.*k.*r)./(lambda.*r).*E0.*A.*B./4.*(1+cos(theta))./2.*cos(phi).* ...
    F0.*F1;

etta = 376.730313461;

U = r.^2.*(abs(Etheta).^2+abs(Ephi).^2)./(2.*etta);




end

