



load ('C:\Users\Amr\Desktop\carplatessigns45.mat')
imDir = fullfile('C:\Users\Amr\Desktop\positiveimages')
addpath(imDir);
negativeFolder=fullfile('D:\Amr\MasterCurrent\ExtractedDataForDetector\Negativeimages')

trainCascadeObjectDetector('stopSignDetector.xml',data,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
trainCascadeObjectDetector('stopSignDetector.xml',data,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
detector = vision.CascadeObjectDetector('stopSignDetector.xml');
img = imread('C:\Users\Amr\Desktop\c4.jpg');
bbox = step(detector, img);
etectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'stop sign');
figure; imshow(etectedImg);



! best training numbers 

nDetector_10stages_far0_5.xml',data,negativeFolder,'FalseAlarmRate',0.5,'NumCascadeStages',9,'TruePositiveRate',0.9999);

