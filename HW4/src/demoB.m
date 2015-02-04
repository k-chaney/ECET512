% Set up parameters for Matlab movie
clear, clc, close all;
iValue = 0;
jValue = 1;
cell_radius = 100;
numFrames = 150;    % Number of images/frames in the movie
numUsers = 2;
lambda = 1;

% Requested parameters
beta = 3;
shadow_variance = 8;
ref_dist = 1; % 1 m
ref_power=1e-3; % 1 mW

n = iValue^2+iValue*jValue+jValue^2;


movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = zeros([numFrames,numUsers]);
for i = 1:numUsers
    mobilePos(:,i) = linspace( randomLocation(n,cell_radius), ...
        randomLocation(n,cell_radius), numFrames );
end;

[cell_nums, tier_nums, cell_centers] = generateCluster( 0, iValue, jValue, cell_radius );
user_names = {};
names={'A_','B_','C_','D_','E_','F_','G_'};
curSize = size(cell_nums);
for i=1:numUsers;
    user_names{i} = strcat('User ', num2str(i));
end

% used to keep track of how many users are connected to each cell over the
% frames
signal_strength = zeros([numFrames,numUsers]);

for index = 1:numFrames    % Draw each frame in the movie
    fig = figure(1);
    set(fig, 'Position', [100, 100, 1049, 895]);
    clf;
    subplot(5,1,[1,2,3]);
    hold on;
    axis off;
    
    
    % Draw the serving cell and label it
    success = drawCluster( cell_nums, tier_nums, ...
        cell_centers, cell_radius );
    
    for i = 1:numUsers
        [ss,si,ci] = findUserInfo(mobilePos(index,i),cell_centers,cell_nums,tier_nums, ...
            cell_radius, ref_dist, ref_power, beta, shadow_variance,lambda);
        
        signal_strength(index,i) = ss;
    end;
    
    axis square;
    hold off;
    subplot(5,1,[4,5]);
    hold on;
    plot( 10*log10(signal_strength(1:index,:)) );
    legend(user_names);
    title('Number of users in each cell');
    xlabel('Frame index');
    ylabel('Power (dB)');
    hold off;
    
    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 30 fps. The movie will
% last numframes/30fps
movie2avi( movieFrames, '../doc/partB.avi','fps',30);