
function  point  = getBestRegion(platescentroids,whiteFeaturesCentroidsMat)
[D I] = pdist2(platescentroids,whiteFeaturesCentroidsMat,'euclidean','Smallest',max(numel(platescentroids),numel(whiteFeaturesCentroidsMat)))

[regionIndexrow, regionIndexcol] = find(abs(D-min(min(D)))<0.001)

% that point is the index of region in plates ,and plates centroids 
point = I(regionIndexrow,regionIndexcol)