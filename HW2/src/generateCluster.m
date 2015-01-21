function [cell_nums, tier_nums, cell_centers] = generateCluster( center_position, iValue, jValue, cellRadius )
% drawCluster.m
%     Kenneth P Chaney
%
%     This program generates multiple hexagnal cells
%
%
%  Parameters:
%     center - Location of the center cell as a complex number X+jY
%     iValue - Corresponds to the distance between like nodes as well as exact location of each
%     jValue -
%     radius - Cell radius specified as a real number
%
%
%  Returns:
%	cell_centers -- centers of all cells
%	cell_nums -- 'frequency' of the cells
%	tier_nums -- which tier a particular cell is located in

cell_centers = [];
cell_nums = [];
tier_nums = [];
cur_center=1;

numFrequencies = iValue^2+iValue*jValue+jValue^2;

cell_height = sqrt(3)*cellRadius;

% keeps track of the name that is being worked on
section_num = 1;

% central cell for first frequency
cell_centers(cur_center) = center_position;
cell_nums(cur_center) = section_num; % translates to an actual name in drawCluster
tier_nums(cur_center) = 1;


temp = ( cell_height * iValue )*1i + ( cos(pi/3) * jValue * cell_height )*1i + ( sin(pi/3) * jValue * cell_height );
angle = atan2(imag(temp),real(temp));
radius = sqrt(imag(temp)^2+real(temp)^2);

% rotates satellite cells around the main cell
for a=1:6
    cell_centers(cur_center+a) = cell_centers(cur_center)+radius*cos(angle+pi/3*a)+radius*sin(angle+pi/3*a)*1i;
    cell_nums(cur_center+a) = 1;% = strcat(names(section_num),num2str(a+1));%names(section_num);
    tier_nums(cur_center+a) = a+1;
end


% creates other frequencyies' central cell and satellite cells
for a=0:numFrequencies-2
    % itterates the portions that keep track of everything
    cur_center = cur_center+7;
    section_num = section_num+1;
    
    % calculates center of new frequency to base the tesseltation on
    center_position = ( cell_height )*1i*cos(a*pi/3)+( cell_height )*sin(a*pi/3);
    cell_centers(cur_center) = center_position;
    cell_nums(cur_center) = section_num; % = strcat(names(section_num),num2str(1));%names(section_num);
    tier_nums(cur_center) = 1;
    % rotates satellite cells around the main cell
    for b=1:6
        cell_centers(cur_center+b) = cell_centers(cur_center)+radius*cos(angle+pi/3*b)+radius*sin(angle+pi/3*b)*1i;
        cell_nums(cur_center+b) = section_num;% = strcat(names(section_num),num2str(b+1));%names(section_num);
	tier_nums(cur_center+b) = b+1;
    end
    
end
