% under GPL v2 Licence
%@author amr abd ellatief   amrabdellatief1@gmail.com
% this function generate and save to the Basic Work space an Array of Regions [0,0,width,height] all of them 
% make sliding window on the Hole Image 
%
%@Param  windowWidth {integer}  the width of sliding window 
%@Param windowHeight {integer} the Height of sliding window
%@Param stride {integer} the displacement of sliding window 
%@Param allWidth {integer} the width of the image
%@Param allHeight {integer} the height of the image
%@return  : this function doesnt return any thing ,just save the plates
%(array of Regions) and save it in the basic workspace with name 'plates'

function  SlidingWindowRegionsGenerator(windowWidth,windowHeight,stride,allWidth,allHeight)

    % get the number of outer Iterations
     numberOfIterations = allHeight/windowHeight;

    % get the number of innner Iterations
     numberOfInnerIterations =(allWidth - windowWidth)/stride;
     
    % refere to the up - left  corner's x Value of the window (start of 0)    
    xlc = 1;
    % refere to the up - left  corner's y value of the window (start of 0)    
    ylc=1;
    % Declare plates Variable
    plates = []
for j = drange(0:numberOfIterations)
    
    for i = drange(0:numberOfInnerIterations)
        Region = [xlc,ylc,windowWidth,windowHeight]
        plates = [plates;Region]
        xlc = xlc + stride
    end
    
xlc = 1;
    ylc = ylc + windowHeight;
end
plates 
assignin('base', 'plates', plates);


