% Demo.m
%     Kapil R. Dandekar
%     ECE-T512 - Wireless Systems Matlab Courseware
%        
%     This program illustrates how the Matlab courseware can be used to
% draw a cell and animate the trajectory of a mobile user moving across
% that cell.
%     The program also captures the output of this animation in a mpeg
% movie file.  More details about creating movies in matlab can be found
% on the Mathworks website or at:
%      http://www.math.canterbury.ac.nz/~csc51/MATLAB_Movies/movies.html


% Set up parameters for Matlab movie
numFrames = 100;    % Number of images/frames in the movie

% Create data structure for matlab movie
%Comment the following line if you don't want to capture a movie and
% only want to see the animation on the screen
%movieFrames = moviein( numFrames, fig1, winSize );
%set( fig1, 'NextPlot', 'replacechildren' );
movieFrames = moviein(numFrames);

% Note that the coordinate system is x+j*y
%  i.e. X is real axis, and Y is imaginary axis
%  Remember to be consistent with your units

% Set location of the mobile user for each frame in the movie
%   (gives the illusion of user movement)
mobilePos = linspace( -50-50*j, 50+50*j, numFrames );

for index = 1:numFrames    % Draw each frame in the movie
    figure(1);
    clf;
    hold on;
    axis off;
    
    % Draw the serving cell and label it
    drawCell( 0, 100, 'A_1' );
    
    % Draw the mobile user at the appropriate location
    plot( mobilePos(index), 'x' );
    
    % Draw a line connecting the center (basestation) of the serving cell 
    %    and the mobile user
    line( [0 real(mobilePos(index))], [0 imag(mobilePos(index))] );
    hold off;

    
    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf );
end

% Translate matlab movie to mpeg format 
% See http://www.math.canterbury.ac.nz/~csc51/MATLAB_Movies/movies.html for more
% details.
% Comment the following line if you don't want to capture a movie and
% only want to see the animation on the screen
%mpgwrite( movieFrames, jet, 'demo.mpg' );

%Write movie in avi format instead (better if you are using a Mac)
movie2avi( movieFrames, 'demo.avi');