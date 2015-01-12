function [cellNumber, tierNumber, center] = findServingCell( mobileLocation, cellCenters, cellNames )
    distances = abs(cellCenters-mobileLocation);
    [minimum,index] = min(distances)
    cellNumber = cellNames(index);
    tierNumber = cellNames(index);
    center = cellCenters(index);