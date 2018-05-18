function trainViolaJones(matricePath,positivemagesPath,negativeImagesPath,falseAlarmRate,numberOfCascadeStages,truePositiveRate)
load (matricePath)
imDir = fullfile(positivemagesPath)
addpath(imDir);
negativeFolder=fullfile(negativeImagesPath)
printmsg = 'iam in test '
%data
%trainCascadeObjectDetector('stopSignDetector.xml',dataTotal2400,negativeFolder,'FalseAlarmRate',falseAlarmRate,'NumCascadeStages',numberOfCascadeStages,'TruePositiveRate',truePositiveRate);
trainCascadeObjectDetector('stopSignDetector.xml',dataTotal2400,negativeFolder,'FalseAlarmRate',falseAlarmRate,'NumCascadeStages',numberOfCascadeStages);

detector = vision.CascadeObjectDetector('stopSignDetector.xml');

