addpath('./images');

% Specify comparison method
support_cmp_name = 'support_cmp_sad';

% Load images
% left_image = imread('images/testL.jpg');
% right_image = imread('images/testR.jpg');

% left_image = imread('images/pentagon_left.bmp');
% right_image = imread('images/pentagon_right.bmp');

left_image = imread('images/scene_l.bmp');
right_image = imread('images/scene_r.bmp');

%right_image = imread('images/scene_l.bmp');

% left_image = imread('images/test2.png');
% right_image = imread('images/test2.png');

% Check if images are greyscale and if not, convert them.
if size(left_image,3) == 3
    left_image = rgb2gray(left_image);
end
if size(right_image,3) == 3
    right_image = rgb2gray(right_image);
end

% allocate space for a disparity map
disp_map = zeros(size(left_image, 1), size(left_image, 2));

% The sizes below are in one direction only - the true window size is 
% (double the specified number + 1).
searchWindowSize = [2 15];
supportWindowSize = [4 4];

searchWindowLengthX = 2*searchWindowSize(1) + 1;
searchWindowLengthY = 2*searchWindowSize(2) + 1;

searchWindowMiddleX = searchWindowSize(1) + 1;
searchWindowMiddleY = searchWindowSize(2) + 1;

supportWindowLengthX = 2*supportWindowSize(1) + 1;
supportWindowLengthY = 2*supportWindowSize(2) + 1;

% define upper and lower limits to allow the disparityMap variable to be
% sliced for parallel execution
xLowerLimit = 1 + searchWindowSize(1) + supportWindowSize(1);
xUpperLimit = size(left_image, 1) - searchWindowSize(1) - supportWindowSize(1);
yLowerLimit = 1 + searchWindowSize(2) + supportWindowSize(2);
yUpperLimit = size(left_image, 2) - searchWindowSize(2) - supportWindowSize(2);

tic
% Compute disparity for each pixel in the reference image
parfor ref_x = xLowerLimit : xUpperLimit
     for ref_y = yLowerLimit : yUpperLimit   
         
        [match_coords, minimum, disparity] = pixel_disp_interp(1,ref_x, ref_y,...
           searchWindowSize, supportWindowSize,...
           left_image, right_image,...
           support_cmp_name);
        
        disp_map(ref_x, ref_y) = disparity;
        
    end
end
toc

refine;
