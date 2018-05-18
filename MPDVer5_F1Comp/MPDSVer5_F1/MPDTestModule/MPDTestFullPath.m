

% repeate  input (path) (FolderName)(fromIndex)(toIndex) (Destination path)  
function MPDTestFullPath(path,folderName,fromIndex,toIndex,DestinationPath)
 %   fullPath = path+'\'+folderName
    paths = GLFindFiles('', fullfile(path,folderName, '*'))
    %getting the Category Names 
    
    for n = drange(fromIndex:toIndex)
        path = paths{n};
        testImg(path);
        plates = evalin('base', 'plates');
        [AverageCatName,CateNames,Regions] = testImgPlatesVsNonPlates(path)
        img = imread(path);
    % [CatName,Region] =testImgMultiPlate(path,Region)
    % Draw Rectangule on the Image Input           
    detectedImg = insertObjectAnnotation(img, 'rectangle', Regions, CateNames)
    %save image to res 
    
    [pathstr,name,ext] = fileparts(path);
    % save Detected Result Region on the Folder 
   % saveTestImageToFolder(path,Region,strcat(pathstr,'\DetectedRegions'),strcat(CatName,'_',num2str(n),'_',name,ext))
    %save complete image with the region box on it 
    imwrite(detectedImg,strcat(pathstr,'\DetectedImages\',AverageCatName,'_',num2str(n),'_',name,ext));
    figure; imshow(detectedImg);

    end