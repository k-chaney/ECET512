function [r,g,b] = generateColor(Pr)
%
%  returns the color for the line that represents signal strength
%
%
%           frissFreeSpace(1) ~ 1
%                   that is treated as ideal value
%
%  Input:
%	-- Pr -- power recieved
%	-- Max -- max power expected to be recieved
%  Output:
%	-- r - red portion
%	-- g - green portion
%	-- b - blue portion


    power = Pr;
    r = max([0,min([1,1-power])]);
    g = max([0,min([1,power])]);
    b = 0;
