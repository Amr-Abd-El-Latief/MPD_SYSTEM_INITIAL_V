% FHDemo_CVPR06_Cal101 - Demo script that performs multiclass classification.
%
% This script runs FHLib against the Caltech 101 dataset using the model
% configuration from our CVPR 2006 paper.  With minor modifications it could run
% on any similar dataset.  The script does everything in the CVPR 2006 paper
% (for the multiclass problem) except the final feature selection step.
%
% (The feature selection step doesn't improve the classification score much --
% it just reduces the number of features needed for the model.  It involves
% learning a lot more features, then iteratively training SVMs and throwing away
% low-weighted features.  It makes for a much more complicated script.)
%
% You will have to copy and edit this script to provide the path of the Caltech
% 101 (or similar) dataset on your system.
%
% You will also need to install the Statistical Pattern Recognition Toolbox for
% MATLAB, available at the following link.  Note that this script was most
% recently tested using version 2.04 of the Toolbox.
%
%    http://cmp.felk.cvut.cz/cmp/software/stprtool/index.html
%
% You might also want to insert "save" commands at appropriate points in this
% script, as it will take some time to run.
%
% See also: FHDemo.

%***********************************************************************************************************************

% Copyright (C) 2007  Jim Mutch  (www.jimmutch.com)
%
% This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
% License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with this program.  If not, see
% <http://www.gnu.org/licenses/>.

%***********************************************************************************************************************

%clc;

% each Var --->   MultiPlate  -->  mPVar  

fprintf('\n');

fprintf('\n');

fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Start of the Train of Multi Plates Stage ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
%while true
%    ans = lower(strtrim(input('All variables will be cleared.  Is this okay (y/n) ? ', 's')));
%    if isempty(ans), continue; end
%    if ans(1) == 'y', break; end
%    if ans(1) == 'n', return; end
%end    


fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Start of the Train of Multi Plates Stage ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');

fprintf('\n');

fprintf('\n');

fprintf('\n');
%clear;

%***********************************************************************************************************************

% Edit this section to supply script parameters.

%dataPath = 'D:\Amr\Amr_Sources\Master\amr master term 2\Master\Dr Al Sayed Eisa\implementation\FHlib\101_ObjectCategories\101_ObjectCategories';        % Path where the Caltech 101 dataset can be found (required).

%dataPath = 'D:\Amr\MasterNewData\Amr_Data_Set';        % Path where the Caltech 101 dataset can be found (required).

%mPDataPath = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\DataSets\Amr_Data_Set';        % Path for plates vs non plates .

%mPDataPath = 'C:\Amr\Master\MasterCurrent\Master27-1-2017\DataSets\Multi_Plate_Categories_70plus';        % Path for plates vs non plates .

%mPDataPath = 'C:\Amr\Master\MasterCurrent\Master27-1-2017\DataSets\Multi_Plate_Categories_70plus_with_FalsePositive';        % Path for plates vs non plates .

mPDataPath = 'C:\Amr\Master\MasterCurrent\Master27-1-2017\DataSets\\Multi_Plate_Categories_400plus_with_FalsePositive';        % Path for plates vs non plates .

%mPDataPath = 'C:\Amr\Master\MasterCurrent\Master27-1-2017\DataSets\Multi_Plate_Categories_with_FalsePositive_40_30_DrSayed';        % Path for plates vs non plates .


%mPDataPathTest = 'D:\Amr\Master\MasterCurrent\Master20-3-2016\DataSets\PlatesvsNoPlate\PlatesvsNoPlateTest';        % Path for plates vs non plates .

%datapath = 'C:\Users\Amr\Desktop\AAADataset\AAADataset';


mPc = FHConfig_CVPR06;  % Model configuration to use.  Note that this script assumes that the only level with learned
                      % features is called "s2" and that the top level is called "c2".

mPNumFeatures = 1500;   % Number of S2 features to learn.
mPNumTrain    = 400;     % Number of training images per category.
mPMaxTest     = 0;    % Maximum number of test images per category.

%***********************************************************************************************************************

if isempty(mPDataPath)
    error('you must edit this script to supply the path of the Caltech 101 dataset (variable "dataPath")');
end


if isempty(which('oaosvm')) || isempty(which('mvsvmclass'))
    error 'the Statistical Pattern Recognition Toolbox for MATLAB (STPRTool) is not in the MATLAB path';
end

if isempty(which('smo_mex'))
    error 'the Statistical Pattern Recognition Toolbox for MATLAB (STPRTool) has not been compiled';
end

%***********************************************************************************************************************

fprintf('CREATING TRAIN/TEST SPLITS\n');

mPCatNames = GLFindDirs(mPDataPath);

mPtrainPaths = cell (1, mPNumTrain * numel(mPCatNames));
mPTrainCats  = zeros(1, mPNumTrain * numel(mPCatNames));
mPTestPaths  = {};
mPTestCats   = [];

for mPI = 1 : numel(mPCatNames)

    mPPaths = GLFindFiles('', fullfile(mPDataPath, mPCatNames{mPI}, '*'));
    if numel(mPPaths) <= mPNumTrain, error('not enough images in category "%s"', mPCatNames{mPI}); end

    mPIndexes = randperm(numel(mPPaths));

    for mPJ = 1 : mPNumTrain
        mPtrainPaths{(mPJ-1) * numel(mPCatNames) + mPI} = mPPaths{mPIndexes(mPJ)};
        mPTrainCats ((mPJ-1) * numel(mPCatNames) + mPI) = mPI;
    end

    mPIndexes = mPIndexes(mPNumTrain + 1 : end);
    if mPMaxTest < numel(mPIndexes), mPIndexes = mPIndexes(1 : mPMaxTest); end
    mPIndexes = sort(mPIndexes);

  %  for j = 1 : numel(indexes)
 %       testPaths{end + 1} = paths{indexes(j)};
 %       testCats (end + 1) = i;
 %   end

end

clear mPI mPPaths mPIndexes mPJ;

%***********************************************************************************************************************

fprintf('INITIALIZING CONFIGURATION AND FEATURE LIBRARY\n');

mPc = FHSetupConfig(mPc);

mPLib = FHSetupLibrary(mPc);

%***********************************************************************************************************************

fprintf('CREATING S2 FEATURE DICTIONARY BY SAMPLING FROM TRAINING IMAGES\n');

mPCount = min(numel(mPtrainPaths), mPNumFeatures);

for mPI = 1 : mPCount

    mPNumSamples = floor(mPNumFeatures / mPCount);
    if mPI <= mod(mPNumFeatures, mPCount), mPNumSamples = mPNumSamples + 1; end

    fprintf('sampling %u feature(s) from %s\n', mPNumSamples, mPtrainPaths{mPI});

    mPSampleDict = FHSampleFeatures(mPc, mPLib, mPtrainPaths{mPI}, 's2', mPNumSamples);

    if mPI == 1
        mPDict = mPSampleDict;
    else
        mPDict = FHCombineDicts(mPc, 's2', mPDict, mPSampleDict);
    end

end

mPDict = FHSparsifyDict(mPc, mPLib, 's2', mPDict, true, 'best*', 1/12, 1);

mPLib = FHSetDict(mPc, mPLib, 's2', mPDict);

clear mPCount mPI mPNumSamples mPSampleDict mPDict;

%***********************************************************************************************************************

fprintf('COMPUTING C2 VECTORS FOR TRAINING IMAGES\n');

mPTrainVectors = zeros(mPNumFeatures, numel(mPtrainPaths), FHFloat);

for mPI = 1 : numel(mPtrainPaths)

    fprintf('computing C2 vector for %s\n', mPtrainPaths{mPI});

    mPTrainVectors(:,mPI) = FHGetResponses(mPc, mPLib, mPtrainPaths{mPI}, 'c2');

end

clear mPI;

%***********************************************************************************************************************


fprintf('BUILDING SVM\n');

mPX = double(mPTrainVectors);

% Find the mean and standard deviation of the response to each feature across the entire training set.
% These statistics will be used to "sphere" the training vectors.

mPFMeans = zeros(size(mPX,1), 1);
mPFStds  = zeros(size(mPX,1), 1);

for mPI = 1 : size(mPX,1)
    mPValues = mPX(mPI, mPX(mPI,:) ~= FHUnknown);
    if isempty(mPValues)
        mPFMeans(mPI) = 0;
        mPFStds (mPI) = Inf;
    else
        mPFMeans(mPI) = mean(mPValues);
        mPFStds (mPI) = std (mPValues);
        if mPFStds(mPI) == 0, mPFStds(mPI) = Inf; end
    end
end

% Sphere the training vectors, setting any "unknown" feature values to the feature mean.

for mPI = 1 : size(mPX,1)
    mPX(mPI, mPX(mPI,:) == FHUnknown) = mPFMeans(mPI);
    mPX(mPI,:) = (mPX(mPI,:) - mPFMeans(mPI)) / mPFStds(mPI);
end

mPData.X = mPX
mPData.y = mPTrainCats

mPOptions.solver = 'smo';
mPOptions.verb   = 1;
mPOptions.ker    = 'linear';
mPOptions.arg    = 1;
mPOptions.C      = Inf;

mPSvm = oaosvm(mPData, mPOptions)
mPSvm2 = oaasvm (mPData, mPOptions)
%pboundary(svm)
%plot (svm);
clear mPX mPI mPValues mPData mPOptions;


assignin('base', 'fMeans', mPFMeans);
assignin('base', 'fStds', mPFStds);



mPTestPaths
mPCatNames
%mPDataPathTest




%************************************************************Test***********************************************************
%************************************************************Test***********************************************************

% i/ps  testPaths   catNames same   dataPathTest maxTest
% 
% 
% clear indexes;
% for i = 1 : numel(catNames)
%     pathsTest = GLFindFiles('', fullfile(dataPathTest, catNames{i}, '*'))
%     if numel(pathsTest) <= maxTest, error('not enough images in category "%s" for test , minimize number of Test Images /or Put more Images in Category : "%s"', catNames{i}); end
%   indexes = randperm(numel(pathsTest));
%   
%    for j = 1 : numTrain
%         testPaths{(j-1) * numel(catNames) + i} = pathsTest{indexes(j)};
%         testCats ((j-1) * numel(catNames) + i) = i;
%     end
% 
%   
%   
%   %  for j = 1 : numel(indexes)
%   %      testPaths{end + 1} = pathsTest{indexes(j)};
%   %      testCats (end + 1) = i;
%   %  end
% 
% end
% fprintf('CLASSIFYING TEST IMAGES\n');
% 
% predCats = zeros(1, numel(testPaths));
% 
% fullScores = zeros(numel(catNames));
% 
% maximumNumberOfTestImages = (maxTest*numel(catNames))
% for i = 1 : maximumNumberOfTestImages
% 
%     testVector = FHGetResponses(c, lib, testPaths{i}, 'c2');
% 	
%     % Sphere the test vector, setting any "unknown" feature values to the feature mean.
% 	
%     x = double(testVector);
%     x(testVector == FHUnknown) = fMeans(testVector == FHUnknown);
%     x = (x - fMeans) ./ fStds;
% 	
%     predCats(i) = mvsvmclass(x, svm);
%     
% 	if predCats(i) == testCats(i)
%         fprintf('%s (correct)\n', testPaths{i});
% 		fullScores(predCats(i),predCats(i))=fullScores(predCats(i),predCats(i))+1
% 		
%     else
%         fprintf('%s (incorrect: %s)\n', testPaths{i}, catNames{predCats(i)});
% 		fullScores(testCats(i),predCats(i))=fullScores(testCats(i),predCats(i))+1
% 		
%     end
% end
% 
% clear i testVector x;
% 
% %*******************************************************  Score ****************************************************************
% %*******************************************************  Score ****************************************************************
% 
% fprintf('COMPUTING CLASSIFICATION SCORE\n');
% 
% scores = zeros(1, numel(catNames));
% 
% 
% for i = 1 : numel(catNames)
% 
%     scores(i) = sum(predCats(testCats == i) == i) / sum(testCats == i) * 100;
% 
% end
% 
% fprintf('average score = %f\n', mean(scores));
% 
% fprintf('score = %f\n', scores);
% 
% fprintf('No Plates');
% 
% fprintf('Plates');
% 
% fprintf('full score = %f\n', fullScores);
% 
% 
% clear i;
% 



fprintf('\n');

fprintf('\n');

fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');


fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End  of the Train of  Multi Plates Stage^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
%while true
%    ans = lower(strtrim(input('All variables will be cleared.  Is this okay (y/n) ? ', 's')));
%    if isempty(ans), continue; end
%    if ans(1) == 'y', break; end
%    if ans(1) == 'n', return; end
%end    


fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End  of the Train of  Multi Plates Stage  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');

fprintf('\n');

fprintf('\n');

fprintf('\n');
