% Set up parameters for Matlab movie
clear, clc, close all;
iValue = 0;
jValue = 1;
cell_radius = 100;
numFrames = 150;    % Number of images/frames in the movie
numUsers = 20;

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
cell_names = {};
names={'A_','B_','C_','D_','E_','F_','G_'};
curSize = size(cell_nums);
for i=1:curSize(2);
    cell_names{i} = strcat(names{cell_nums(i)}, num2str(tier_nums(i)));
end

% used to keep track of how many users are connected to each cell over the
% frames
connected_users = zeros([numFrames,7*n]);

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
            cell_radius, ref_dist, ref_power, beta, shadow_variance);
        
        connected_users(index,ci)=connected_users(index,ci)+1;
    end;
    
    axis square;
    hold off;
    
    subplot(5,1,[4,5]);
    hold on;
    plot( connected_users(1:index,:) );
    legend(cell_names);
    title('Number of users in each cell');
    xlabel('Frame index');
    ylabel('Num users');
    hold off;
    
    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
movie2avi( movieFrames, '../doc/partB.avi','fps',30);