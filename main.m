clear;
rng('default');

addpath('./images');

% https://uk.mathworks.com/help/vision/ref/disparity.html
% Load images
left_image = imread('images/testL.jpg');
right_image = imread('images/testR.jpg');

% Check if images are greyscale and if not convert them
if size(left_image,3) == 3
    left_image = rgb2gray(left_image);
end
if size(right_image,3) == 3
    right_image = rgb2gray(right_image);
end

% Show stereo anaglyph. Use red-cyan stereo glasses to view image in 3-D.
figure
imshow(stereoAnaglyph(left_image,right_image));
title('Red-cyan composite view of the stereo images');

% Compute the disparity map.
disparityRange = [-6 10];
disparityMap = disparity(left_image,right_image,'BlockSize',...
    15,'DisparityRange',disparityRange);

% Display the disparity map. For better visualization, 
% use the disparity range as the display range for imshow.
figure 
imshow(disparityMap,disparityRange);
title('Disparity Map');
colormap(gca,jet) 
colorbar
