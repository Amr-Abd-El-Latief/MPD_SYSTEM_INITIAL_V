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

fprintf('\n');

fprintf('\n');

fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Start of the Train of Plates Vs Non Plates Stage ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
%while true
%    ans = lower(strtrim(input('All variables will be cleared.  Is this okay (y/n) ? ', 's')));
%    if isempty(ans), continue; end
%    if ans(1) == 'y', break; end
%    if ans(1) == 'n', return; end
%end    


fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Start of the Train of Plates Vs Non Plates Stage ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');

fprintf('\n');

fprintf('\n');

fprintf('\n');
%clear;

%***********************************************************************************************************************

% Edit this section to supply script parameters.

%dataPath = 'D:\Amr\Amr_Sources\Master\amr master term 2\Master\Dr Al Sayed Eisa\implementation\FHlib\101_ObjectCategories\101_ObjectCategories';        % Path where the Caltech 101 dataset can be found (required).

%dataPath = 'D:\Amr\MasterNewData\Amr_Data_Set';        % Path where the Caltech 101 dataset can be found (required).

dataPath = 'C:\Amr\Master\MasterCurrent\Master20-3-2016\DataSets\PlatesvsNoPlate\PlatesvsNoPlate';        % Path for plates vs non plates .

%get current path
%currentPath = pwd

% add the viola Jones Sub System 
%addpath(strcat(currentPath,'..\Data\ViolaData\les', '\ViolaJonesModule'));



%dataPathTest = 'D:\Amr\Master\MasterCurrent\Master20-3-2016\DataSets\PlatesvsNoPlate\PlatesvsNoPlateTest';        % Path for plates vs non plates .

%datapath = 'C:\Users\Amr\Desktop\AAADataset\AAADataset';


c = FHConfig_CVPR06;  % Model configuration to use.  Note that this script assumes that the only level with learned
                      % features is called "s2" and that the top level is called "c2".

numFeatures = 4075;   % Number of S2 features to learn.
numTrain    = 5;     % Number of training images per category.
maxTest     = 0;    % Maximum number of test images per category.

%***********************************************************************************************************************

if isempty(dataPath)
    error('you must edit this script to supply the path of the Caltech 101 dataset (variable "dataPath")');
end


if ~exist(fullfile(GLAbsPath(dataPath), 'plates'), 'dir')
    error('cannot find the Caltech 101 dataset at path "%s"', dataPath);
end

if isempty(which('oaosvm')) || isempty(which('mvsvmclass'))
    error 'the Statistical Pattern Recognition Toolbox for MATLAB (STPRTool) is not in the MATLAB path';
end

if isempty(which('smo_mex'))
    error 'the Statistical Pattern Recognition Toolbox for MATLAB (STPRTool) has not been compiled';
end

%***********************************************************************************************************************

fprintf('CREATING TRAIN/TEST SPLITS\n');

catNames = GLFindDirs(dataPath);

trainPaths = cell (1, numTrain * numel(catNames));
trainCats  = zeros(1, numTrain * numel(catNames));
testPaths  = {};
testCats   = [];

for i = 1 : numel(catNames)

    paths = GLFindFiles('', fullfile(dataPath, catNames{i}, '*'));
    if numel(paths) <= numTrain, error('not enough images in category "%s"', catNames{i}); end

    indexes = randperm(numel(paths));

    for j = 1 : numTrain
        trainPaths{(j-1) * numel(catNames) + i} = paths{indexes(j)};
        trainCats ((j-1) * numel(catNames) + i) = i;
    end

    indexes = indexes(numTrain + 1 : end);
    if maxTest < numel(indexes), indexes = indexes(1 : maxTest); end
    indexes = sort(indexes);

  %  for j = 1 : numel(indexes)
 %       testPaths{end + 1} = paths{indexes(j)};
 %       testCats (end + 1) = i;
 %   end

end

clear i paths indexes j;

%***********************************************************************************************************************

fprintf('INITIALIZING CONFIGURATION AND FEATURE LIBRARY\n');

c = FHSetupConfig(c);

lib = FHSetupLibrary(c);

%***********************************************************************************************************************

fprintf('CREATING S2 FEATURE DICTIONARY BY SAMPLING FROM TRAINING IMAGES\n');

count = min(numel(trainPaths), numFeatures);

for i = 1 : count

    numSamples = floor(numFeatures / count);
    if i <= mod(numFeatures, count), numSamples = numSamples + 1; end

    fprintf('sampling %u feature(s) from %s\n', numSamples, trainPaths{i});

    sampleDict = FHSampleFeatures(c, lib, trainPaths{i}, 's2', numSamples);

    if i == 1
        dict = sampleDict;
    else
        dict = FHCombineDicts(c, 's2', dict, sampleDict);
    end

end

dict = FHSparsifyDict(c, lib, 's2', dict, true, 'best*', 1/12, 1);

lib = FHSetDict(c, lib, 's2', dict);

clear count i numSamples sampleDict dict;

%***********************************************************************************************************************

fprintf('COMPUTING C2 VECTORS FOR TRAINING IMAGES\n');

trainVectors = zeros(numFeatures, numel(trainPaths), FHFloat);

for i = 1 : numel(trainPaths)

    fprintf('computing C2 vector for %s\n', trainPaths{i});

    trainVectors(:,i) = FHGetResponses(c, lib, trainPaths{i}, 'c2');

end

clear i;

%***********************************************************************************************************************


fprintf('BUILDING SVM\n');

x = double(trainVectors);

% Find the mean and standard deviation of the response to each feature across the entire training set.
% These statistics will be used to "sphere" the training vectors.

fMeans = zeros(size(x,1), 1);
fStds  = zeros(size(x,1), 1);

for i = 1 : size(x,1)
    values = x(i, x(i,:) ~= FHUnknown);
    if isempty(values)
        fMeans(i) = 0;
        fStds (i) = Inf;
    else
        fMeans(i) = mean(values);
        fStds (i) = std (values);
        if fStds(i) == 0, fStds(i) = Inf; end
    end
end

% Sphere the training vectors, setting any "unknown" feature values to the feature mean.

for i = 1 : size(x,1)
    x(i, x(i,:) == FHUnknown) = fMeans(i);
    x(i,:) = (x(i,:) - fMeans(i)) / fStds(i);
end

data.X = x;
data.y = trainCats;

options.solver = 'smo';
options.verb   = 1;
options.ker    = 'linear';
options.arg    = 1;
options.C      = Inf;

svm = oaosvm(data, options)
svm2 = oaasvm (data, options)
%pboundary(svm)
%plot (svm);
clear x i values data options;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assignin('base', 'fMeans', fMeans);
assignin('base', 'fStds', fStds);

testPaths
catNames
%dataPathTest

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End of the Train of Plates Vs Non Plates Stage ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
%while true
%    ans = lower(strtrim(input('All variables will be cleared.  Is this okay (y/n) ? ', 's')));
%    if isempty(ans), continue; end
%    if ans(1) == 'y', break; end
%    if ans(1) == 'n', return; end
%end    


fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ End  of the Train of Plates Vs Non Plates Stage ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');

fprintf('\n');

fprintf('\n');

fprintf('\n');
