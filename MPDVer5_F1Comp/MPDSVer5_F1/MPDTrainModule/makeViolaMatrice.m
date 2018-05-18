% under GPL v2 Licence
%@author amr abd ellatief   amrabdellatief1@gmail.com
% this function generate and return  viola jones matrice to train violajones cascade matlab classifier with bounding box [0,0,image width , image height]  
% and saves the output 
%
%
%@Note you must to run AddPaths file first 
%@ you must to run GLSetpath  first too
% repeate  input (path) (FolderName)(fromIndex)(toIndex) (Destination path)  
function generatedData = makeViolaMatrice(path,folderName,fromIndex,toIndex,DestinationPath)
 %   fullPath = path+'\'+folderName
    paths = GLFindFiles('', fullfile(path,folderName, '*'))
    generatedData = [];
    for n = drange(fromIndex:toIndex)
        path = paths{n}
        img = imread(path)
        [height , width] = size(img);
 
        field = 'imageFilename';
        value = path;
       
        field2 = 'objectBoundingBoxes';
        value2 = [1,1,width/3,height];
        
        temp = struct(field,value,field2,value2);
        generatedData = [generatedData,temp]
        save('generatedData.mat','generatedData') 
        
    end