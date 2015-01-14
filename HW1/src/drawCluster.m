function success = drawCluster( cell_names, cell_positions, cell_radius )
% drawCluster.m
%     Kenneth P Chaney
%        
%     This program draws multiple hexagnal cells
%
%
%  Parameters:
%     cell_names - name to be printed on each cell
%     cell_positions - center of each cell
%     cell_radius - cell radius, same for all cells ( although this could change )
%
%  Returns:
%     success - 0 if good, 1 if arrays don't match, 2 if the array is truly multi dimensional

success = 0;

% just some checks to make sure the data all lines up with where it should be 
if( size(cell_names) ~= size(cell_positions) )
	success = 1;
	return;
end

curSize = size(cell_names);

for i=1:curSize(2);
	drawCell( cell_positions(i), cell_radius, cell_names{i}, 'k' );
end
