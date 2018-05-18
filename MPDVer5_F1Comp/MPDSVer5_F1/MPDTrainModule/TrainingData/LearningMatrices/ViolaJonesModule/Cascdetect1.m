function Cascdetect1 ()
field = 'f';
value = {'some text';
[10, 20, 30];
magic(5)};
s = struct(field,value)
field = 1;
val = {"c1.jpg";233;255;266;288};
val = {"c1.jpg";233;255;266;288};
val = {"c1.jpg";[233,255,266,288]};
val = {'c1.jpg';[233,255,266,288]};
s = struct(field,val)
field = "first"
field = 'first'
s = struct(field,val)
load('stopSigns.mat');
imDir = fullfile(matlabroot,'toolbox','vision','visiondemos','stopSignImages');
addpath(imDir);
negativeFolder = fullfile(matlabroot,'toolbox','vision','visiondemos','non_stop_signs');
trainCascadeObjectDetector('stopSignDetector.xml',data,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
detector = vision.CascadeObjectDetector('stopSignDetector.xml');
img = imread('stopSignTest.jpg');
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');
figure;
imshow(detectedImg);
rmpath(imDir);
1
val = {'c1.jpg';[233,255,266,288]};
s = struct(val)
val = {'c1.jpg';[233,255,266,288]};
s = struct(val);
val = {'c1.jpg';[233,255,266,288]};
field = 'f';
value = {'some text';
[10, 20, 30];
magic(5)};
s = struct(field,value)
val = {'c1.jpg';[233,255,266,288]};
j = 'ttt'
y =[233,255,266,288]
field = 'c1.jpg';
y =[233,255,266,288]
s = struct(field,y)
s = struct(field,y);
y ={[233,255,266,288]}
s = struct(field,y);
s = struct('amr',y);
s = struct('imageFilename','c1.jpg','objectBoundingBoxes',y);
end
