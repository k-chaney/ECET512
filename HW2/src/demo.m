% Set up parameters for Matlab movie

iValue = 2;
jValue = 1;
cell_radius = 100;

numFrames = 150;    % Number of images/frames in the movie

movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = linspace( -100-100*1i,100+100*1i, numFrames );

mobile_power = zeros([numFrames,1]);

[cell_nums, tier_nums, cell_centers] = generateCluster( 0, iValue, jValue, cell_radius );

for index = 1:numFrames    % Draw each frame in the movie
    fig = figure(1);
    %fig.Position = [100,100,900,900];
    clf;
    subplot(5,1,[1,2,3]);
    hold on;
    axis off;
    
    
    % Draw the serving cell and label it
    success = drawCluster( cell_nums, tier_nums, ...
        cell_centers, cell_radius );
    
    % draws the mobile user info and pulls back the current mobile power
    mobile_power(index) = findUserInfo(mobilePos(index), ...
        cell_centers,cell_nums,tier_nums,cell_radius);
    
    axis square;
    hold off;
    
    subplot(5,1,[4,5]);
    hold on;
    plot(mobile_power(1:index));
    title('Mobile user signal strength');
    xlabel('Frame index');
    ylabel('Signal strength (dBm)');
    hold off;
    
    % Capture the frame for the movie
    %movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
% movie2avi( movieFrames, '../doc/demo.avi','fps',30);
