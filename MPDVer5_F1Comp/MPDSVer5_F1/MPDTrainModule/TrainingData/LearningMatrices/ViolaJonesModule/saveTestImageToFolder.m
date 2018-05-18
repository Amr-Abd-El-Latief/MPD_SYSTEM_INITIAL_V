function saveTestImageToFolder(readImagePath,RegionBbox,PathsavePath,nameWithExtention)

img = imread(readImagePath);
imgPart=img(RegionBbox(1,2):RegionBbox(1,2)+RegionBbox(1,4),RegionBbox(1,1):RegionBbox(1,1)+RegionBbox(1,3),:);
completeImgName = strcat(PathsavePath,'\',nameWithExtention)
imwrite(imgPart,completeImgName);