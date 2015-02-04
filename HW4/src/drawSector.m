function a = drawSector( center, radius, color, angle )
% drawCell.m
%        
%     This program draws a triangular sector.
%
%  Note that the coordinate system is x+j*y
%    i.e. X is real axis, and Y is imaginary axis
%  Remember to be consistent with your units
%


% trial and error here
if angle<-2/3*pi
    sectorNum = 4;
elseif angle<-pi/3
    sectorNum = 5;
elseif angle<0
    sectorNum = 6;
elseif angle<pi/3
    sectorNum = 1;
elseif angle<2/3*pi
    sectorNum = 2;
elseif angle<pi
    sectorNum = 3;
end

a = center + radius * exp(j*pi*[(sectorNum-1)*2:2:sectorNum*2]'/6);
plot([center, a(1), center, a(2)], color)
plot(a, 'b')
