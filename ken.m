clear;
rng('default');

addpath('./images');

% Specify comparison method
support_cmp_name = 'support_cmp_sad';

% Load images
%left_image = imread('images/testL.jpg');
%right_image = imread('images/testR.jpg');

left_image = imread('images/pentagon_left.bmp');
right_image = imread('images/pentagon_right.bmp');

%left_image = imread('images/scene_l.bmp');
%right_image = imread('images/scene_r.bmp');

% Check if images are greyscale and if not, convert them.
if size(left_image,3) == 3
    left_image = rgb2gray(left_image);
end
if size(right_image,3) == 3
    right_image = rgb2gray(right_image);
end

% allocate space for a disparity map
disparityMap = zeros(size(left_image, 1), size(left_image, 2));

% The sizes below are in one direction only - the true window size is 
% (double the specified number + 1).
searchWindowSize = [5 5];
supportWindowSize = [3 3];

searchWindowLengthX = 2*searchWindowSize(1) + 1;
searchWindowLengthY = 2*searchWindowSize(2) + 1;

searchWindowMiddleX = searchWindowSize(1) + 1;
searchWindowMiddleY = searchWindowSize(2) + 1;

supportWindowLengthX = 2*supportWindowSize(1) + 1;
supportWindowLengthY = 2*supportWindowSize(2) + 1;

% Compute disparity for each pixel in the reference image
for ref_x = 1 + searchWindowSize(1) + supportWindowSize(1) : size(left_image, 1) - searchWindowSize(1) - supportWindowSize(1)
    for ref_y = 1 + searchWindowSize(2) + supportWindowSize(2) : size(left_image, 2) - searchWindowSize(2) - supportWindowSize(2)
        
        [match_coords, minimum, disparity] = pixel_disp(ref_x, ref_y,...
           searchWindowSize, supportWindowSize,...
           left_image, right_image,...
           support_cmp_name);
        
        disparityMap(ref_x, ref_y) = disparity;
        
    end
end

figure;
imagesc(disparityMap);
colormap(gray);
colorbar
hold on;

figure;
imshow(left_image);
