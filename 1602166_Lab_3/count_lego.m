function [numA, numB] = count_lego(I)


img = I;

%Find range of blue values on the Hue Saturation Spectrum. 
blueRange = [0.5 0.7]; 
minimumSaturation = 0.5; 
minimumRegionSize = 20000;

% Use Gaussian to denoise input image
filerImage = imfilter(img, fspecial('gaussian', 10, 2));
% Convert image to HSV format
hulesatration = rgb2hsv(filerImage);



% Threshold the hue to keep pixels in blue range
% pixels
blueBin = hulesatration(:,:,1) > blueRange(1) & hulesatration(:,:,1) < blueRange(2) & hulesatration(:,:,2) > minimumSaturation;
blueBin = bwmorph(blueBin, 'close'); % Morpohlogical structuring to tidy up image shapes. 




%Region Props filter to create bounding box around it and get following
%properties. 
regsBlue = regionprops(blueBin, 'Area', 'MajorAxisLength','MinorAxisLength','Centroid', 'BoundingBox');

%remove any regions that are below minimum region size. 
regsBlue(vertcat(regsBlue.Area) < minimumRegionSize) = [];

%Initalise numA to be of the number of values. 
numA = length(regsBlue);

%For all regins
for k = 1:length(regsBlue)
    
    disp(k);
    
%caluculate the ratio between the Minimum and Maximum Axis length.
          ratio = regsBlue(k).MinorAxisLength/regsBlue(k).MajorAxisLength;
       
            %If ratio not within range, then reduce number
           disp(ratio);
           if(ratio<0.45) || (ratio>0.6)
                   numA = numA-1;
                   disp('numA reduced by minor major');
               
               
           else
               disp('Ratio Condition within range');
           end        
          
           
          
end


%Same as decribed above, but with Red hue saturation values. 

redRange = [0.8 1]; 
imgfiltRed = imfilter(img, fspecial('gaussian', 10, 2));
hsvImgRed = rgb2hsv(imgfiltRed);

redBin = hsvImgRed(:,:,1) > redRange(1) & hsvImgRed(:,:,1) < redRange(2) & hsvImgRed(:,:,2) > minimumSaturation;
redBin = bwmorph(redBin, 'close');


regsRed = regionprops(redBin,'Area', 'MajorAxisLength','MinorAxisLength','Centroid', 'BoundingBox') ;


minRegionsizeRed = 5000;
regsRed(vertcat(regsRed.Area) < minRegionsizeRed) = [];

numB = length(regsRed);

for k = 1:length(regsRed)
    
    disp(k);

          ratio = regsRed(k).MinorAxisLength/regsRed(k).MajorAxisLength;
       

           disp(ratio);
           
           if (ratio < 0.76)
               if(ratio<0.55) || (ratio>0.6)
                       numB = numB-1;
                       disp('numA reduced by minor major');


               else
                   disp('Ratio Condition within range');
               end      
           
           end
          
end


disp(numA);
disp(numB);



end
