clear, clc, close all;

% Set up parameters
numFrames = 150;
iValue = 2;
jValue = 1;
centerPosition = 0;
cellRadius = 100;

% DONT EDIT BELOW THIS

movieFrames = moviein(numFrames);

% generates linearly spaced vector
% dumb random assignment right now. Not parameterized.
mobilePos = linspace( -randi(100)-250-(randi(100)+100)*1i, ...
    randi(200)-100+(randi(200)+200)*1i, numFrames );
mobile_power = zeros([numFrames,1]);

[cell_names, cell_centers] = generateCluster( centerPosition, iValue, jValue, ... 
    cellRadius );

userColor = [];

for index = 1:numFrames    % Draw each frame in the movie
    fig = figure(1);
    fig.Position = [200,200,900,900]; % kludge need to do this properly
    clf;
    subplot(4,1,[1,2,3]);
    hold on;
    axis off;

    
    % finds the serving cell for the single user that is being presented
    [connected_cell_num, connected_tier_num, connected_cell_position] = ... 
        findServingCell(mobilePos(index), cell_centers, cell_names );
    
    
    mobile_power(index) = friisFreeSpace(abs(connected_cell_position-mobilePos(index)));
    
    % Generate the color for the user and connection
    [r,g,b] = generateColor(mobile_power(index));
    
    
    % draw cluster
    success = drawCluster( cell_names, cell_centers, 100 );
    
    % Draw the serving cell and label it
    drawCell( connected_cell_position, 100, connected_cell_num, 'r' );
    
    % Draw the mobile user at the appropriate location
    plot( mobilePos(index), '*', 'Color', [r,g,b] );
    
    % Draw a line connecting the center (basestation) of the serving cell 
    %    and the mobile user
    line( [real(connected_cell_position) real(mobilePos(index))], ...
        [imag(connected_cell_position) imag(mobilePos(index))], ...
        'Color', [r,g,b] );
    
    axis square;
    hold off;
    subplot(4,1,4);
    hold on;
    plot(mobile_power(1:index));
    title('Mobile user signal strength');
    xlabel('Frame index');
    ylabel('Signal strength');
    hold off;

    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 15 fps. The movie will
% last numframes/15fps
movie2avi( movieFrames, '../doc/demo.avi','fps',15);
