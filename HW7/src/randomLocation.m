function [ location ] = randomLocation( n, cell_radius )
% generates a random location on the generated map with n channels
    angle = rand()*2*pi;
    location = rand()*sqrt(3)*n*cell_radius*((cos(angle))+(sin(angle))*1i);
end

