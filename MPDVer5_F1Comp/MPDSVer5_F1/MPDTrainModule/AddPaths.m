%get current path
currentPath = pwd

% add the viola Jones Sub System 
addpath(strcat(currentPath,'\trainingModules', '\ViolaJonesModule'))

% add the FH Sub System
addpath(strcat(currentPath,'\trainingModules', '\FHLibR8Module'))
 