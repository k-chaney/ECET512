function [ sA ] = binary2symbol( bA )

% bA must be a MxN matrix where M is number of samples and N is number of
% bits per symbol
    s = size(bA);
    sA = zeros(s(1),1);
    for i=1:s(2)
        sA=sA+(bA(:,i).*(2^(i-1)));
    end

end

