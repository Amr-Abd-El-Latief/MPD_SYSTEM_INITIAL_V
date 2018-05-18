function testImg(imgPath)

img = imread(imgPath);
detector = vision.CascadeObjectDetector('stopSignDetector.xml');
bbox = step(detector, img)
 assignin('base', 'plates', bbox)
 platesCentroids = [bbox(:,1)+bbox(:,3)/2, bbox(:,2)+bbox(:,4)/2];
 assignin('base', 'platescentroids', platesCentroids)
detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'Plate');
figure; imshow(detectedImg);

