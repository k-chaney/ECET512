% Set up parameters for Matlab movie
clear, clc, close all;

M = 4;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
n = 2^15;                  % Number of bits to process

SNR = 10^(5/10); % plot from 0dB to 15dB

numSamplesPerSymbol = 1;    % Oversampling factor

dataIn = randi([0 1],2*n,1);  % Generate vector of binary data

dataInMatrix = reshape(dataIn,length(dataIn)/k,k);   % Reshape data into binary 4-tuples

dataSymbolsIn = binary2symbol(dataInMatrix);% Convert to symbols

transmit_signal = qammod(dataInMatrix,M,0);

fc = 1.9E9;
fm = 20;

[r_n, dur] = rayleighFad(n, fc, fm);
dur = dur(1:end-1)';
r_n = r_n(1:end-1)';
r_n = (r_n-mean(r_n));
%r_n = r_n./std(r_n)^2;
figure
plot(dur,r_n);
h_n = 10.^(r_n./10).*exp(-j*unifrnd(0,2*pi,length(r_n),1));
n_n=(1/SNR)^2*unifrnd(0,1,length(r_n),1);
y_n = transmit_signal+n_n./h_n;
figure
plot(y_n,'*')
hold on
plot(transmit_signal,'g*')
hold off

binary_recieved = qamdemod(y_n);

nE = numErrors(dataInMatrix,binary_recieved);
disp(['BER = ' num2str(nE/n)]);