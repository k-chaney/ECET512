% Set up parameters for Matlab movie
clear, clc, close all;
iValue = 1;
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

ibeta1S = zeros([numFrames,1]);
ibeta1NoS = zeros([numFrames,1]);
ibeta2S = zeros([numFrames,1]);
ibeta2NoS = zeros([numFrames,1]);

sbeta1S = zeros([numFrames,1]);
sbeta1NoS = zeros([numFrames,1]);
sbeta2S = zeros([numFrames,1]);
sbeta2NoS = zeros([numFrames,1]);

[cell_nums, tier_nums, cell_centers] = generateCluster( ...
    0, iValue, jValue, cell_radius );

N = iValue^2+jValue*iValue+jValue^2;

SIR_center_beta1 = ones([numFrames,1])*sqrt(3*N)^beta1/6;
SIR_edge_beta1 = ones([numFrames,1])*1/(2*((sqrt(3*N)-1)^-beta1+sqrt(3*N)^-beta1+(sqrt(3*N)+1)^-beta1));

SIR_center_beta2 = ones([numFrames,1])*sqrt(3*N)^beta2/6;
SIR_edge_beta2 = ones([numFrames,1])*1/(2*((sqrt(3*N)-1)^-beta2+sqrt(3*N)^-beta2+(sqrt(3*N)+1)^-beta2));

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
    
    
    sbeta1S(index) = dbm2power(pathLossModel(ref_dist, ref_power, beta1, shadow_variance, ...
        abs(mobilePos(index)-connected_cp))); % in watts
    sbeta1NoS(index) = dbm2power(pathLossModel(ref_dist, ref_power, beta1, 0, ...
        abs(mobilePos(index)-connected_cp))); % in watts
    sbeta2S(index) = dbm2power(pathLossModel(ref_dist, ref_power, beta2, shadow_variance, ...
        abs(mobilePos(index)-connected_cp))); % in watts
    sbeta2NoS(index) = dbm2power(pathLossModel(ref_dist, ref_power, beta2, 0, ...
        abs(mobilePos(index)-connected_cp))); % in watts
    
    
    indicies = find( cell_nums == connected_cn );
    for a=indicies
        if(tier_nums(a) ~= connected_tn)
            drawCell( cell_centers(a), cell_radius, '', 'r' );
            line( [real(cell_centers(a)) real(mobilePos(index))], ...
                [imag(cell_centers(a)) imag(mobilePos(index))], ...
                'Color', 'r' );
            
            ibeta1S(index) = (ibeta1S(index)) + dbm2power( ...
                pathLossModel(ref_dist, ref_power, beta1, shadow_variance, ...
                abs(mobilePos(index)-cell_centers(a))));
            ibeta1NoS(index) = (ibeta1NoS(index)) + dbm2power( ...
                pathLossModel(ref_dist, ref_power, beta1, 0, ...
                abs(mobilePos(index)-cell_centers(a))));
            ibeta2S(index) = (ibeta2S(index)) + dbm2power( ...
                pathLossModel(ref_dist, ref_power, beta2, shadow_variance, ...
                abs(mobilePos(index)-cell_centers(a))));
            ibeta2NoS(index) = (ibeta2NoS(index)) + dbm2power( ...
                pathLossModel(ref_dist, ref_power, beta2, 0, ...
                abs(mobilePos(index)-cell_centers(a))));
            
        end;
    end;
    
    
    axis square;
    hold off;
    
    subplot(5,1,[4,5]);
    hold on;
    plot(10*log10(sbeta1S(1:index)./ibeta1S(1:index)),'g');
    plot(10*log10(sbeta1NoS(1:index)./ibeta1NoS(1:index)),'r');
    plot(10*log10(sbeta2S(1:index)./ibeta2S(1:index)),'b');
    plot(10*log10(sbeta2NoS(1:index)./ibeta2NoS(1:index)),'k');
    legend('B=3 Shadowing','B=3 No Shadowing','B=4 Shadowing','B=4 No Shadowing');
    title('Mobile user signal strength');
    xlabel('Frame index');
    ylabel('SIR (dBm)');
    hold off;
    
    % Capture the frame for the movie
    %movieFrames(:, index) = getframe(gcf);
    
end

% outputs movie to doc folder with a framerate of 60 fps. The movie will
% last numframes/15fps
%movie2avi( movieFrames, '../doc/partB.avi','fps',30);

figure(2);

hold on;
plot(10*log10(sbeta2S(1:index)./ibeta2S(1:index)),'b');
plot(10*log10(sbeta2NoS(1:index)./ibeta2NoS(1:index)),'k');
plot(10*log10(SIR_edge_beta2),'g');
plot(10*log10(SIR_center_beta2),'r');
legend('B=4 Shadowing','B=4 No Shadowing','Edge Estimation','Center Estimation');
title(['Mobile user signal strength N=' num2str(N)]);
xlabel('Frame index');
ylabel('SIR (dB)');
hold off;


figure(3);
hold on;
plot(10*log10(sbeta1S(1:index)./ibeta1S(1:index)),'b');
plot(10*log10(sbeta1NoS(1:index)./ibeta1NoS(1:index)),'k');
plot(10*log10(SIR_edge_beta1),'g');
plot(10*log10(SIR_center_beta1),'r');
legend('B=3 Shadowing','B=3 No Shadowing','Edge Estimation','Center Estimation');
title(['Mobile user signal strength N=' num2str(N)]);
xlabel('Frame index');
ylabel('SIR (dB)');
hold off;