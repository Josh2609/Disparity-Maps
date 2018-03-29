% computes disparity map for a stereo pair using the named algorithm. (x and y values are swapped internally to match MatLAB's row&column format)
function [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y)

% allocate space for the disparity map
disp_map = zeros(size(left_image, 1), size(left_image, 2));

% The sizes below are in one direction only - the true window size is 
% (double the specified number + 1).
searchWindowSize = [search_size_y search_size_x];
supportWindowSize = [support_size_y support_size_x];

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
time = toc;
end