
function [AverageCatName,ResultCatNames,RegionBboxes] = testImgMultiPlatesVsNonPlatesLevelTwo(imgPath)
AddPaths
	
	c = evalin('base', 'mPc');
    lib = evalin('base', 'mPLib');
    catNames = evalin('base', 'mPCatNames');
	 plates = evalin('base', 'Regions');
     
    fMeans = evalin('base', 'mPFMeans');
    fStds = evalin('base', 'mPFStds');
    svm = evalin('base', 'mPSvm');    
     [ m , n ] = size(plates) 
	 
 %     saveTestImageToFolder(imgPath,bbox(n,:),strcat(pathstr,'\data'),strcat(num2str(n),'data',name,ext))
    img = imread(imgPath);
	RegionBboxes = [];
    ResultCatNames = {};
    ResultCatNumbers = [];
    AverageCatName = '';
    
     for n = drange(1:m)     
      RegionBbox =  plates(n,:)
	  
     % Sphere the test vector, setting any "unknown" feature values to the feature mean.
	imgPart=img(RegionBbox(1,2):RegionBbox(1,2)+RegionBbox(1,4),RegionBbox(1,1):RegionBbox(1,1)+RegionBbox(1,3),:);
    testVector = FHGetResponses(c, lib, imgPart, 'c2');	    %takes Time 

 x = double(testVector);
    x(testVector == FHUnknown) = fMeans(testVector == FHUnknown);
    x = (x - fMeans) ./ fStds;
            
    predCatNumber = mvsvmclass(x, svm);
    CatName = catNames{predCatNumber}
	if  strcmp(CatName,'falser_Positive')
        fprintf('Found NO plate !!!!');
		fprintf('O2O2O2O2');
    else
      fprintf('Found  Plate of Type :');
	  fprintf(CatName);
	  RegionBboxes = [RegionBboxes;RegionBbox]
      temp = [ResultCatNames;CatName]
      ResultCatNames = temp;
      ResultCatNumbers = [ResultCatNumbers;predCatNumber]
      
     AverageCatName =catNames{int8(mean(ResultCatNumbers))}
	  fprintf('V2V2V2V2');
    end
    % getting the average of classes of the detected Regions 
            
     end
  
end

    

	