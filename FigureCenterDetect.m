% FigureCenterDetect:find out the center of circle(sun), rectangle/square(cloud)
% Step 1: Read image Read in
% Step 2: Convert image from rgb to gray 
% Step 3: Threshold the image
% Step 4: Invert the Binary Image
% Step 5: Find the boundaries Concentrate
% Step 6: Determine Shapes properties
% Step 7: Classify Shapes according to properties
% Square      = 3
% Rectangular = 2
% Circle      = 1
% UNKNOWN     = 0
%------------------------------------------------------------------------
function [sun,cloud] = FigureCenterDetect(RGB)
GRAY = rgb2gray(RGB);
threshold = graythresh(GRAY);
BW = im2bw(GRAY, threshold);
[B,L] = bwboundaries(BW, 'noholes');

STATS = regionprops(L, 'all'); 
for i = 1 : length(STATS)
  W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1);
  W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
  centroid = STATS(i).Centroid;
  switch W(i)
      case 1
          sun = [centroid(1),centroid(2)];
      case 2
          cloud = [centroid(1),centroid(2)];
      case 3
          cloud = [centroid(1),centroid(2)];
  end
end