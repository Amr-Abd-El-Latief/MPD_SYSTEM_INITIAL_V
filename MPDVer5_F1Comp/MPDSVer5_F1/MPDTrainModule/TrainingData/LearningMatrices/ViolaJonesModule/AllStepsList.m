% adding to start file of matlab 
    % adding libraries to matlap path
run D:\Amr\Master\MasterCurrent\Master20-3-2016\stprtool22dec04\stprtool\stprpath.m
run D:\Amr\Master\MasterCurrent\Master20-3-2016\FHLibR8\FHLib\GLSetPath    

positiveFolder = 'D:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages'
negativeFolder='D:\Amr\Master\MasterCurrent\Master20-3-2016\Negativeimages'
matricepath = 'D:\Amr\Master\MasterCurrent\Master20-3-2016\carplatessignsfinal150.mat'
trainViolaJones(matricepath,positiveFolder,negativeFolder,0.2,5,0.9999)


% repeate  input (path) (FolderName)(fromIndex)(toIndex) (Destination path)  
  %  paths = GLFindFiles('', fullfile('D:\Amr\MasterCurrent\Master20-3-2016\','positiveimages', '*'));
    testImg('D:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages\11.jpg')
    SimpleColorDetectionByHue
    getBestRegion(platescentroids,whiteFeaturesCentroidsMat)    
    showRegion('D:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages\11.jpg',2)  
    showRegion('D:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages\11.jpg',1)
    saveTestImageToFolder('D:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages\11.jpg',plates(1,:),'D:\TestVector\','fTest.jpg')
% End of repeate 
% repeate untill output the output vector 
% train the FHlib 
% test on the output vector      >>> make the FHLib get the tested image from one third outer Folder
% manual first time 
% >>>>enhance the Hue in one function 