% Set up parameters for Matlab movie
clear, clc, close all;


f = 1.8e9; % 1.8GHz operating frequency
lambda = 3e8/f;
dist = lambda/2;
numAntennas=10;
antennaLocations = [[0:1:numAntennas]*dist;[0:1:numAntennas]*0];
theta_test = [1:1:180-1]*pi/180;
theta=pi/3;
omega = 2*pi*(3e8/lambda);


% set specifics that shouldn't be changed for this but might actually be
% safe to change
iValue = 0;
jValue = 1;
cell_radius = 100;
numFrames = 150;    % Number of images/frames in the movie
numUsers = 1;

beta = 3;
shadow_variance = 8;
ref_dist = 1; % 1 m
ref_power=1e-3; % 1 mW
n = iValue^2+iValue*jValue+jValue^2;


movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = zeros([numFrames,numUsers]);
for i = 1:numUsers
    mobilePos(:,i) = linspace( randomLocation(n/2,cell_radius), ...
        randomLocation(n/2,cell_radius), numFrames );
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
signal_phase = zeros([numFrames,numUsers]);

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
        userSignals = signalSimulation( mobilePos(index,i), antennaLocations, f);
        P(i,:) = estDOA( userSignals, mobilePos(index,i), antennaLocations, f, theta_test );
        signal_strength(index,i) = ss;
    end;
    
    axis square;
    hold off;
    subplot(5,1,[4,5]);
    hold on;
    plot( P'./max(P) );
    legend(user_names);
    title('DOA Estimation');
    xlabel('Theta (degrees)');
    ylabel('Normalized Spectrum');
    hold off;
    
    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 30 fps. The movie will
% last numframes/30fps
movie2avi( movieFrames, '../doc/partA.avi','fps',30);
saveas(fig,['../doc/partA.png']);