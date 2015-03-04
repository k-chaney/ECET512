function [ dataMod ] = qammod( dataIn, M, phase_off )
%QAMMOD -- dataIn must be an M by N matrix
% M is the number of symbols
% N is the number of bits per symbol
    s=size(dataIn);
    dataMod=zeros(s(1),1);
    
    for i=1:s(1)
       if dataIn(i,1)==1
          dataMod(i)=dataMod(i)+1;
       else
          dataMod(i)=dataMod(i)-1;
       end
       if dataIn(i,2)==1
          dataMod(i)=dataMod(i)+j;
       else
          dataMod(i)=dataMod(i)-j;
       end
    end
    dataMod=dataMod/sqrt(2);
    % 00 -- [-1.00000000000000 - 1.00000000000000i]
    % 01 -- [-1.00000000000000 + 1.00000000000000i]
    % 10 -- [1.00000000000000 - 1.00000000000000i]
    % 11 -- [1.00000000000000 + 1.00000000000000i]

end

