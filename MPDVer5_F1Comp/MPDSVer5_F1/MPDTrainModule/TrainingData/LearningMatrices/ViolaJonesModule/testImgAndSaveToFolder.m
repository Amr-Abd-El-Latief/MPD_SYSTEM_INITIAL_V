function testImgData(imgPath)

img = imread(imgPath);
detector = vision.CascadeObjectDetector('stopSignDetector.xml');
bbox = step(detector, img)
[pathstr,name,ext] = fileparts(imgPath)
[ m , n ] = size(bbox) 
 for n = drange(1:m)     
    saveTestImageToFolder(imgPath,bbox(n,:),strcat(pathstr,'\data'),strcat(num2str(n),'data',name,ext))
 end
 assignin('base', 'plates', bbox)
 platesCentroids = [bbox(:,1)+bbox(:,3)/2, bbox(:,2)+bbox(:,4)/2];
 assignin('base', 'platescentroids', platesCentroids)
detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'Plate');
imwrite(detectedImg,strcat(pathstr,'\data'),strcat(num2str(n),'dataFull',name,ext));
figure; imshow(detectedImg);

