% Set up parameters
clear, clc, close all;

N = 2^10;
fc = 1.9E9;
fm = [20,200];
dBTolerance = [0,-10];

mag = [];
dur = [];

for a=1:2
    for b=1:2
        for i=1:100
            [mag(i,:), dur] = rayleighFad(N, fc, fm(a));
        end
        
        rms = mean(mag);
        numCrossings = zeros([1,100]); % specific crossing points
        duration = zeros([1,100]);
        
        for i=1:100
            % finds all crossings and counts the length then divides by two
            % (for both directions)
            tmp = sign(mag(i,:)-rms-dBTolerance(b));
            crossings = find(diff( tmp ));
            
            numCrossings(i)=length(crossings)/2;
            
            % counts the duration of the crossing
            for c=1:length(tmp)
                if(tmp(c)==-1)
                    duration(i)=duration(i)+1;
                end
            end
            
        end
        figure(1)
        plot(dur(2:200),mag(i,2:200))
        title({'{\bf{Simulation of the Clark and Gans Fading Model}}'; ...
            'f_c = 1.9 GHz, f_m = 20Hz, N = 8192'})
        xlabel('Time (s)')
        ylabel('Magnitude (dB)')
        % gets the mean across all tests and divides by total time in a
        % test
        CPS = mean(numCrossings)/(dur(end)-dur(1));
        
        % counted number of duration blocks below threshold--take mean and
        % multiply by amount of time in a single block
        EFD = mean(duration)*(dur(2)-dur(1));
        
        disp(['Average Number of Crossings Per Second = ' num2str(CPS) ' for f_m=' ...
            num2str(fm(a)) ' dB Tolerance of ' num2str(dBTolerance(b))]);
        disp(['Average Envelope Fade Duration = ' num2str(EFD) ' for f_m=' ...
            num2str(fm(a)) ' dB Tolerance of ' num2str(dBTolerance(b))]);
    end
end