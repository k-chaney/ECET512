% Set up parameters for Matlab movie
clear, clc, close all;
iValue = 0;
jValue = 1;
cell_radius = 2000/sqrt(3);
numFrames = 150;    % Number of images/frames in the movie

% Requested parameters
beta = 2.9;
shadow_variance = 10^(4/10);
ref_dist = 1; % 1 m
ref_power=dbm2power(0);

handoffStation = sqrt(3)*cell_radius*1i;

n = iValue^2+iValue*jValue+jValue^2;


movieFrames = moviein(numFrames);

% generates linearly spaced vector
mobilePos = linspace( 0, handoffStation, numFrames );

[cell_nums, tier_nums, cell_centers] = generateCluster( 0, iValue, jValue, cell_radius );

BS1_S = zeros([numFrames,1]);
BS1_NS = zeros([numFrames,1]);
BS2_S = zeros([numFrames,1]);
BS2_NS = zeros([numFrames,1]);

Pmin = -88;

speed = 22.3;
deltaT = 4.5;
deltaD = speed*deltaT;

dOneMin = 10^(-Pmin/(10*beta));

PrH0=-10*beta*log10(dOneMin-deltaD);

handoff_s = zeros([numFrames,1]);
handoff_ns = zeros([numFrames,1]);

handoff_state_s = 0;
handoff_state_ns = 0; % 0 is starting cell    1 is during handoff   2 is done

for index = 1:numFrames    % Draw each frame in the movie
    fig = figure(1);
    set(fig, 'Position', [100, 100, 1049, 895]);
    clf;
    subplot(6,1,[1,2,3]);
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
    
    line( [0 real(mobilePos(index))], ...
        [0 imag(mobilePos(index))], ...
        'Color', 'r' );
    
    line( [0 real(mobilePos(index))], ...
        [imag(handoffStation) imag(mobilePos(index))], ...
        'Color', 'b' );
    
    BS1_S(index) = dbm2power( ...
        pathLossModel(ref_dist, ref_power, beta, shadow_variance, ...
        abs(mobilePos(index)-0)));
    BS1_NS(index) = dbm2power( ...
        pathLossModel(ref_dist, ref_power, beta, 0, ...
        abs(mobilePos(index)-0)));
    BS2_S(index) = dbm2power( ...
        pathLossModel(ref_dist, ref_power, beta, shadow_variance, ...
        abs(mobilePos(index)-handoffStation)));
    BS2_NS(index) = dbm2power( ...
        pathLossModel(ref_dist, ref_power, beta, 0, ...
        abs(mobilePos(index)-handoffStation)));
    if(index>10)
        if(handoff_state_s==0)
            handoff_s(index)=0;
            if((mean(BS1_S(index-5:index))<dbm2power(PrH0)))
                handoff_state_s=1;
            end
        elseif(handoff_state_s==1)
            handoff_s(index)=1;
            if((mean(BS2_S(index-5:index))>dbm2power(PrH0)))
                handoff_state_s=2;
            end
        else
            handoff_s(index)=0;
        end;

        handoff_ns(index) = ((mean(BS2_NS(index-5:index))<dbm2power(PrH0)) ... 
            * (mean(BS1_NS(index-5:index))<dbm2power(PrH0)));
    end;
    axis square;
    hold off;
    
    subplot(6,1,[4,5]);
    hold on;
    plot( power2dbm(BS1_S(1:index)), 'k' );
    plot( power2dbm(BS1_NS(1:index)), 'b' );
    plot( power2dbm(BS2_S(1:index)), 'r' );
    plot( power2dbm(BS2_NS(1:index)), 'g' );
    plot( Pmin*ones([1,index]), 'c' );
    plot( PrH0*ones([1,index]), 'm' );
    legend({'BS1 Shadowing','BS1 No Shadowing', ...
        'BS2 Shadowing','BS2 No Shadowing','Pmin','P_{rH0}'});
    title('Power from user to base station');
    xlabel('Frame index');
    ylabel('Power (dBm)');
    hold off;
    
    subplot(6,1,6);
    hold on;
    xlabel('Frame index');
    ylabel('Handoff Occuring');
    plot(handoff_s(1:index),'g');
    plot(handoff_ns(1:index),'b');
    legend({'Handoff Shadowing','Handoff No Shadowing'});
    hold off;
    
    % Capture the frame for the movie
    movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
movie2avi( movieFrames, '../doc/partA.avi','fps',30);