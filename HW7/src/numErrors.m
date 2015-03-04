function [ nE ] = numErrors( b1, b2 )
%BER input two arrays of binary numbers outputs the number of errors
% size(b1)==size(b2)

nE = length( find((b1-b2)~=0) );

end

