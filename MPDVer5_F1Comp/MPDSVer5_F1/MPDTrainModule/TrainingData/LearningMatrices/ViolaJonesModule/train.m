function train(imgPath)

img = imread(imgPath);
detector = vision.CascadeObjectDetector('stopSignDetector.xml');
bbox = step(detector, img)
detectedImg = insertObjectAnnotation(img, 'rectangle', bbox, 'plate');
figure; imshow(detectedImg);

