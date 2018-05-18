
%{
this function take folder path full of images, and produces parts of those
images in the Destination Folder

Matlab Version  13a

@Author amr abd el latief  amr.a.ellatief@gmail.com
@Licence : Gnu 2
@Param path {type : string }: the path to the folder of input images    
@Param folderName {type : string }: the name of the folder of images  i.e.  fullPath = path+'\'+folderName 
@Param  fromIndex {type : integer} : the begining image to consider of the image in the folder of image
@Param toIndex {type : integer} : the last image to consider in the folder
@Param widthFactor {type : fraction , from 0  -- to -- 1} : its the percent of the width of the part of the image will be,
@Param heightFactor {type : fraction , from 0  -- to -- 1} : its the percent of the height of the part of the image will be,
@Param destinationPAth {type : string }: the path to the folder of output (parts of images)  
%}


function GenerateImageParts(path,folderName,fromIndex,toIndex,widthFactor,heightFactor,destinationPAth)
 %   fullPath = path+'\'+folderName
    paths = GLFindFiles('', fullfile(path,folderName, '*'))
    for n = drange(fromIndex:toIndex)
        path = paths{n};
        % read the image
        img = imread(path);
        % log the path of the image to console
        path
        %get the name and extension of an Image
        [pathstr,name,ext] = fileparts(path);
        [height , width] = size(img)
        Region = [1,1,width/3,height]
        %get part of the image
        RegionPart=[1,1,Region(1,3)*widthFactor,Region(1,4)*heightFactor]
        % getting the important part of the image
        imgPart=img(RegionPart(1,2):RegionPart(1,2)+RegionPart(1,4)-1,RegionPart(1,1):RegionPart(1,1)+RegionPart(1,3)-1,:)
        %show the image befor store it, for Test
        %figure; imshow(imgPart);
        % save image part to Destination  Folder 
       imwrite(imgPart,strcat(destinationPAth,'\',num2str(n),'_',name,ext)); 

    end