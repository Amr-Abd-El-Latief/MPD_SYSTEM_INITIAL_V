%from TrainViolaJonesModule
path = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\TestVectors'



% from train viola jones Comp  trainViolaJonesComp    //   
positiveFolder = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\positiveimages';
negativeFolder='C:\Amr\Master\MasterCurrent\Master20-3-2016\Negativeimages';
matricepath = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\carplatessignsfinal150.mat';




%get current path
currentPath = pwd

% add positive folder for viola jones 
positiveFolder = strcat(currentPath,'..\Data\ViolaData\positiveimages')
% add negative folder for viola jones 
negativeFolder=strcat(currentPath,'..\Data\ViolaData\Negativeimages')
% add matrice path 
matricepath = strcat(currentPath,'..\Data\ViolaData\carplatessignsfinal150.mat')


%********************** note the matrice path   c: ... positive images 


%plates vs non plates from file : FHDemo_Plates_Vs_NonPlatesVersion2

dataPath = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\DataSets\PlatesvsNoPlate\PlatesvsNoPlate';        % Path for plates vs non plates .


% multi plates stage   in file: FHDemo_Multi_PlatesVersion2

mPDataPath = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\DataSets\Amr_Data_Set';        % Path for plates vs non plates .

