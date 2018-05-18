%positiveFolder = 'D:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages';
%negativeFolder='D:\Amr\Master\MasterCurrent\Master20-3-2016\Negativeimages';
%matricepath = 'D:\Amr\Master\MasterCurrent\Master20-3-2016\carplatessignsfinal150.mat';

%get current path
currentPath = pwd

% add positive folder for viola jones 
positiveFolder = strcat(currentPath,'TrainingData\ViolaData\positiveimages')
% add negative folder for viola jones 
negativeFolder=strcat(currentPath,'\TrainingData\ViolaData\Negativeimages')
% add matrice path 
matricepath = strcat(currentPath,'\TrainingData\LearningMatrices\carplatessignsfinal150.mat')

trainViolaJones(matricepath,positiveFolder,negativeFolder,0.2,15)

