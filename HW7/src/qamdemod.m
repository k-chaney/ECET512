function [ binary ] = qamdemod( signal )
%QAMDEMOD signal_recieve must be an M by 1 matrix
% M is the number of symbols
% returns an M by N matrix
% N is the number of bits per symbol

    % 00 -- [-1.00000000000000 - 1.00000000000000i]
    % 01 -- [-1.00000000000000 + 1.00000000000000i]
    % 10 -- [1.00000000000000 - 1.00000000000000i]
    % 11 -- [1.00000000000000 + 1.00000000000000i]
    
binary = zeros(length(signal),2);

binary(:,1) = (real(signal)>0);
binary(:,2) = (imag(signal)>0);

end

