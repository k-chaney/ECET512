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
numFrames = 150;    % Number of images/frames in the movie

movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = linspace( -50-50*j, 50+50*j, numFrames );
[names, centers] = generateCluster( 0, 1, 1, 100 );

for index = 1:numFrames    % Draw each frame in the movie
    figure(1);
    clf;
    hold on;
    axis off;
    
    % Draw the serving cell and label it
    success = drawCluster( names, centers, 100 );
    
    % Draw the mobile user at the appropriate location
    plot( mobilePos(index), 'x' );
    
    % Draw a line connecting the center (basestation) of the serving cell 
    %    and the mobile user
    line( [0 real(mobilePos(index))], [0 imag(mobilePos(index))] );
    hold off;

    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf );
end

% outputs movie to doc folder with a framerate of 15 fps. The movie will
% last numframes/15fps
movie2avi( movieFrames, '../doc/demo.avi','fps',15);