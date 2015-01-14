function [cellNumber, tierNumber, center] = findServingCell( mobileLocation, cellCenters, cellNames )
%
%  Finds the serving cell for an individual user. Takes advantage of working in
%  the complex plain and with vectors.
%
%  Inputs:
%	- mobileLocation -- location on the complex plane
%	- cellCenters -- all cell centers within the simulated area
%	- cellNames -- all cell names within the simulated area
%			cellCenters and cellNames are parallel arrays
%
%
%  Outputs:
%	- cellNumber -- returns the cell name chosen
%	- tierNumber -- returns the cell name chosen
%	- center -- returns the center of the cell chosen in the complex plane

    % pulls distances from current mobileLocation
    distances = abs(cellCenters-mobileLocation);
    % pulls the closest cell from the vector of distances
    [minimum,index] = min(distances);
    cellNumber = cellNames{index};
    tierNumber = cellNames{index};
    center = cellCenters(index);
