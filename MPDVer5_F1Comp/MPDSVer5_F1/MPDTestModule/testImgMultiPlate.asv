
function [CatName,RegionBbox] = testImgMultiPlate(imgPath,RegionBbox)
AddPaths
    c = evalin('base', 'mPc');
    lib = evalin('base', 'mPLib');
    catNames = evalin('base', 'mPCatNames');
 %  plates = evalin('base', 'mPPlates');
    fMeans = evalin('base', 'mPFMeans');
    fStds = evalin('base', 'mPFStds');
    svm = evalin('base', 'mPSvm');
       
    %  saveTestImageToFolder(imgPath,bbox(n,:),strcat(pathstr,'\data'),strcat(num2str(n),'data',name,ext))
    img = imread(imgPath);
    
    % Sphere the test vector, setting any "unknown" feature values to the feature mean.
   % RegionBbox(1,1)
   % RegionBbox(1,2)
   % RegionBbox(1,3)
   % RegionBbox(1,4)
   % RegionBbox(1,2)+RegionBbox(1,4)
   % RegionBbox(1,1)+RegionBbox(1,3)
   
	imgPart=img(RegionBbox(1,2):RegionBbox(1,2)+RegionBbox(1,4)-1,RegionBbox(1,1):RegionBbox(1,1)+RegionBbox(1,3)-1,:);
    testVector = FHGetResponses(c, lib, imgPart, 'c2');	
 
    x = double(testVector);
    x(testVector == FHUnknown) = fMeans(testVector == FHUnknown);
    x = (x - fMeans) ./ fStds;
            
    fprintf('predCatNumber ******************* ')
    predCatNumber = mvsvmclass(x, svm)

    
    CatName = catNames{predCatNumber}

    fprintf('Found plate of type  :   ');
    fprintf(CatName);
% 	if  CatName = 'plates'
%         fprintf('Found plate ');
% 		break;
%     else
%       fprintf('Found No Plate ');
%     end
       
    

	