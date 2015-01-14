% Set up parameters for Matlab movie
numFrames = 150;    % Number of images/frames in the movie

movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = linspace( -randi(100)-250-(randi(100)+100)*1i, ...
    randi(200)-100+(randi(200)+200)*1i, numFrames );

[cell_names, cell_centers] = generateCluster( 0, 2, 1, 100 );

userColor = [];

for index = 1:numFrames    % Draw each frame in the movie
    figure(1);
    clf;
    hold on;
    axis off;

    % finds the serving cell for the single user that is being presented
    [connected_cell_num, connected_tier_num, connected_cell_position] = findServingCell( ...
        mobilePos(index), cell_centers, cell_names );
    
    % Draw the serving cell and label it
    success = drawCluster( cell_names, cell_centers, 100 );
    drawCell( connected_cell_position, 100, connected_cell_num, 'r' );
    
    % Generate the color for the user and connection
    [r,g,b] = generateColor(abs(connected_cell_position-mobilePos(index)));
    
    % Draw the mobile user at the appropriate location
    plot( mobilePos(index), '*', 'Color', [r,g,b] );
    
    % Draw a line connecting the center (basestation) of the serving cell 
    %    and the mobile user
    line( [real(connected_cell_position) real(mobilePos(index))], ...
        [imag(connected_cell_position) imag(mobilePos(index))], ...
        'Color', [r,g,b] );
    
    axis square;
    hold off;

    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
movie2avi( movieFrames, '../doc/demo.avi','fps',30);
