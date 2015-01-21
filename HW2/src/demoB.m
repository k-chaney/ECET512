% Set up parameters for Matlab movie
clear, clc, close all;
iValue = 2;
jValue = 1;
cell_radius = 100;
numFrames = 150;    % Number of images/frames in the movie

% Requested parameters
beta1 = 3;
beta2 = 4;
shadow_variance = 8;
ref_dist = 1; % 1 m
ref_power=1e-3; % 1 mW


movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = linspace( -100-100*1i,100+100*1i, numFrames );

beta1S = zeros([numFrames,1]);
beta1NoS = zeros([numFrames,1]);
beta2S = zeros([numFrames,1]);
beta2NoS = zeros([numFrames,1]);

[cell_nums, tier_nums, cell_centers] = generateCluster( 0, iValue, jValue, cell_radius );

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
    
    
    % finds the serving cell for the single user that is being presented
    [connected_cn, connected_tn, connected_cp] = findServingCell( ...
        mobilePos(index), cell_centers, cell_nums, tier_nums );
    drawCell( connected_cp, cell_radius, '', 'g' );
    
    % Draw the mobile user at the appropriate location
    plot( mobilePos(index), '*', 'Color', 'k' );
    
    % Draw a line connecting the center (basestation) of the serving cell
    %    and the mobile user
    line( [real(connected_cp) real(mobilePos(index))], ...
        [imag(connected_cp) imag(mobilePos(index))], ...
        'Color', 'g' );
    
    indicies = find( cell_nums == connected_cn );
    for a=indicies
        if(tier_nums(a) ~= connected_tn)
            drawCell( cell_centers(a), cell_radius, '', 'r' );
            line( [real(cell_centers(a)) real(mobilePos(index))], ...
                [imag(cell_centers(a)) imag(mobilePos(index))], ...
                'Color', 'r' );
            
            beta1S(index) = (beta1S(index)) + dbm2power( ... 
                pathLossModel(ref_dist, ref_power, beta1, shadow_variance, ...
                abs(mobilePos(index)-cell_centers(a))));
            beta1NoS(index) = (beta1NoS(index)) + dbm2power( ... 
                pathLossModel(ref_dist, ref_power, beta1, 0, ...
                abs(mobilePos(index)-cell_centers(a))));
            beta2S(index) = (beta2S(index)) + dbm2power( ... 
                pathLossModel(ref_dist, ref_power, beta2, shadow_variance, ...
                abs(mobilePos(index)-cell_centers(a))));
            beta2NoS(index) = (beta2NoS(index)) + dbm2power( ... 
                pathLossModel(ref_dist, ref_power, beta2, 0, ...
                abs(mobilePos(index)-cell_centers(a))));
            
        end;
    end;
    
    
    axis square;
    hold off;
    
    subplot(5,1,[4,5]);
    hold on;
    plot(power2dbm(beta1S(1:index)),'g');
    plot(power2dbm(beta1NoS(1:index)),'r');
    plot(power2dbm(beta2S(1:index)),'b');
    plot(power2dbm(beta2NoS(1:index)),'k');
    legend('B=3 Shadowing','B=3 No Shadowing','B=4 Shadowing','B=4 No Shadowing');
    title('Mobile user signal strength');
    xlabel('Frame index');
    ylabel('Signal strength (dBm)');
    hold off;
    
    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
 movie2avi( movieFrames, '../doc/partB.avi','fps',30);
 
figure(2);

hold on;
plot(power2dbm(beta1S(1:index)),'g');
plot(power2dbm(beta1NoS(1:index)),'r');
plot(power2dbm(beta2S(1:index)),'b');
plot(power2dbm(beta2NoS(1:index)),'k');
legend('B=3 Shadowing','B=3 No Shadowing','B=4 Shadowing','B=4 No Shadowing');
title('Mobile user signal strength');
xlabel('Frame index');
ylabel('Signal strength (dBm)');
hold off;