
function dataStruct=nameImages(dataStruct,startIndex,endIndex)
pattern ='/[0-9]+';


for index =startIndex:endIndex
  dataStruct(1,index).imageFilename=regexprep(dataStruct(1,index).imageFilename,pattern,strcat('/',num2str(index)));

end

end
    






