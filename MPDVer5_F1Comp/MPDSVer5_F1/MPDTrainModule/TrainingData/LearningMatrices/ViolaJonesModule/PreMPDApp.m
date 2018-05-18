%run D:\Amr\Master\MasterCurrent\Master20-3-2016\stprtool22dec04\stprtool\stprpath.m
%run D:\Amr\Master\MasterCurrent\Master20-3-2016\FHLibR8\FHLib\GLSetPath    


%run D:\Amr\Master\MasterCurrent\Master20-3-2016\FHLibR8\FHLib\FH\MPDSVer2\MPDTrainModule\UtilModules\stprtool22dec04\stprtool\stprpath.m
%run D:\Amr\Master\MasterCurrent\Master20-3-2016\FHLibR8\FHLib\FH\MPDSVer2\MPDTrainModule\trainingModules\FHLibR8Module\FHLib\GLSetPath    


%get current path
currentPath = pwd

% add the viola Jones Sub System 
run (strcat(currentPath,'\UtilModules\stprtool22dec04\stprtool\stprpath.m'))

% add the FH Sub System
run (strcat(currentPath,'\trainingModules', '\FHLibR8Module\FHLib\GLSetPath'))
