

% repeate  input (path) (FolderName)(fromIndex)(toIndex) (Destination path)  
function MPDTestMultiPlatesPath(path,folderName,fromIndex,toIndex,DestinationPath)
 %   fullPath = path+'\'+folderName
    paths = GLFindFiles('', fullfile(path,folderName, '*'))
    for n = drange(fromIndex:toIndex)
        path = paths{n};
%        testImg(path);
%        plates = evalin('base', 'plates');
%       [CatName,Region] = testImgPlatesVsNonPlates(path)
            img = imread(path);
            path
            [height , width] = size(img)
            Region = [1,1,width/3,height]
          
         [CatName,Region] =testImgMultiPlate(path,Region)
    % Draw Rectangule on the Image Input           
    detectedImg = insertObjectAnnotation(img, 'rectangle', Region, CatName);
    %save image to res 
    
    [pathstr,name,ext] = fileparts(path);
    % save Detected Result Region on the Folder 
    saveTestImageToFolder_multiPath(path,Region,strcat(pathstr,'\DetectedRegions'),strcat(CatName,'_',num2str(n),'_',name,ext))
    %save complete image with the region box on it 
    imwrite(detectedImg,strcat(pathstr,'\DetectedImages\',CatName,'_',num2str(n),'_',name,ext));
 %   figure; imshow(detectedImg);

    end