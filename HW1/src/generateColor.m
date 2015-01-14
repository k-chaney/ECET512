function [r,g,b] = generateColor(d)
%
%  returns the color for the line that represents signal strength
%
%
%           frissFreeSpace(1) ~ 1
%                   that is treated as ideal value
%
%  Input:
%	-- d -- distance
%  Output:
%	-- r - red portion
%	-- g - green portion
%	-- b - blue portion


    power = friisFreeSpace(d);
    r = max([0,min([1,1-power])]);
    g = max([0,min([1,power])]);
    b = 0;
