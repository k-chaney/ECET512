function [cell_names, cell_centers] = generateCluster( center_position, iValue, jValue, cellRadius )
% drawCluster.m
%     Kenneth P Chaney
%        
%     This program draws multiple hexagnal cells
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

names={'A_','B_','C_','D_','E_','F_','G_',};
cell_centers = [];
cell_names = {};
cur_center=1;

cell_height = sqrt( cellRadius * 3 / 2 );

% keeps track of the name that is being worked on
section_num = 1;

cell_centers(cur_center)=center_position;
cell_names(cur_center)=names(section_num);
cur_center=cur_center+1;

temp = ( cell_height * iValue ) + ( cos(pi/3) * jValue * cell_height ) + ( sin(pi/3) * jValue * cell_height )*j;
cell_centers(cur_center) = temp;
cell_names(cur_center)=names(section_num);
angle = atan2(imag(temp),real(temp));
radius = sqrt(imag(temp)^2+real(temp)^2);
cell_centers(cur_center+1)=radius*cos(angle+pi/3)+radius*sin(angle+pi/3)*1i;
cell_names(cur_center+1)=names(section_num);

