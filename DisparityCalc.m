function disparity_map = DisparityCalc(slide_length, support_cmp_name, left_image_path, right_image_path, supp_x, supp_y, search_x, search_y, refinement, refinement_iterations)
f = waitbar(0,'Please wait...');
pause(.5)
rng('default');

addpath('./images');

% Load images
left_image = imread(left_image_path);
right_image = imread(right_image_path);

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
searchWindowSize = [search_y search_x];
supportWindowSize = [supp_y supp_x];

% define upper and lower limits to allow the disparityMap variable to be
% sliced for parallel execution
xLowerLimit = 1 + searchWindowSize(1) + supportWindowSize(1);
xUpperLimit = size(left_image, 1) - searchWindowSize(1) - supportWindowSize(1);
yLowerLimit = 1 + searchWindowSize(2) + supportWindowSize(2);
yUpperLimit = size(left_image, 2) - searchWindowSize(2) - supportWindowSize(2);

waitbar((0.1),f,'Calculating Disparities... ');
tic
% Compute disparity for each pixel in the reference image
parfor ref_x = xLowerLimit : xUpperLimit
     for ref_y = yLowerLimit : yUpperLimit   
         
        [~, ~, disparity] = pixel_disp_interp(slide_length,ref_x, ref_y,...
           searchWindowSize, supportWindowSize,...
           left_image, right_image,...
           support_cmp_name);
        
        disp_map(ref_x, ref_y) = disparity;
        
     end
end
waitbar((0.8),f,'Finishing Disparity Map... ');
toc
if(refinement == 1)
    waitbar((0.9),f,'Refining Disparity Map... ');
    disparity_map = refine_disp_map(disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit, refinement_iterations);
end
close(f);
