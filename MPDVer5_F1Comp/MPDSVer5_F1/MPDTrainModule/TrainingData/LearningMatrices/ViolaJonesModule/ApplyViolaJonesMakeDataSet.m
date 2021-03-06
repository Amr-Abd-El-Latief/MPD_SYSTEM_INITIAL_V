
% repeate  input (path) (FolderName)(fromIndex)(toIndex) (Destination path)  
function ApplyViolaJones(path,folderName,fromIndex,toIndex,DestinationPath)
 %   fullPath = path+'\'+folderName
    paths = GLFindFiles('', fullfile(path,folderName, '*'))
    for n = drange(fromIndex:toIndex)
        n
        path = paths{n}
        testImgAndSaveToFolder(path)
        HueFilter(path);
        platescentroids = evalin('base', 'platescentroids')
        whiteFeaturesCentroidsMat = evalin('base', 'whiteFeaturesCentroidsMat')
        regionIndexInPlates = getBestRegion(platescentroids,whiteFeaturesCentroidsMat);    
        %showRegion(path,2)  
        showRegion(path,regionIndexInPlates)
        plates = evalin('base', 'plates');
        saveTestImageToFolder(path,plates(regionIndexInPlates,:),DestinationPath,strcat(num2str(n),'Test.jpg'))
    end
    
% End of repeate 
% repeate untill output the output vector 
% train the FHlib 
% test on the output vector      >>> make the FHLib get the tested image from one third outer Folder
% manual first time 

% >>>>enhance the Hue in one function 