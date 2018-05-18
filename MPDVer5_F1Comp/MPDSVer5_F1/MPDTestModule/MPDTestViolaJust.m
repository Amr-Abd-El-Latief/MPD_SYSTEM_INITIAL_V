
% repeate  input (path) (FolderName)(fromIndex)(toIndex) (Destination path)  
function MPDTestViolaJust(path,folderName,fromIndex,toIndex,DestinationPath)
 %   fullPath = path+'\'+folderName
    paths = GLFindFiles('', fullfile(path,folderName, '*'))
    for n = drange(fromIndex:toIndex)
        path = paths{n};
        testImg(path);
     end