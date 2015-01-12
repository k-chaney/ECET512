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
mobilePos = linspace( -250-100*j, 100+250*j, numFrames );
[cell_names, cell_centers] = generateCluster( 0, 0, 2, 100 );

for index = 1:numFrames    % Draw each frame in the movie
    figure(1);
    clf;
    hold on;
    axis off;
    
    [cell_num, tier_num, center_cell_position] = findServingCell( ...
        mobilePos(index), cell_centers, cell_names );
    
    % Draw the serving cell and label it
    success = drawCluster( cell_names, cell_centers, 100 );
    
    % Draw the mobile user at the appropriate location
    plot( mobilePos(index), 'x' );
    
    % Draw a line connecting the center (basestation) of the serving cell 
    %    and the mobile user
    line( [real(center_cell_position) real(mobilePos(index))], [imag(center_cell_position) imag(mobilePos(index))] );
    axis square;
    hold off;

    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
movie2avi( movieFrames, '../doc/demo.avi','fps',60);