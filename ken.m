clear;
rng('default');

addpath('./images');

% Load images
left_image = imread('images/testL.jpg');
right_image = imread('images/testR.jpg');

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

supportWindowCount = searchWindowLengthX * searchWindowLengthY;

% Compute disparity for each pixel in the reference image
for ref_x = 1 + searchWindowSize(1) + supportWindowSize(1) : size(left_image, 1) - searchWindowSize(1) - supportWindowSize(1)
    for ref_y = 1 + searchWindowSize(2) + supportWindowSize(2) : size(left_image, 2) - searchWindowSize(2) - supportWindowSize(2)
        
        % matrix to hold the aggregated values from each support window
        support_aggregates = zeros(searchWindowLengthX, searchWindowLengthY);
        
        %populate reference support window with image pixel intensities
        support_ref = left_image(...
            ref_x - supportWindowSize(1) : ref_x + supportWindowSize(1), ...
            ref_y - supportWindowSize(2) : ref_y + supportWindowSize(2));
        
        for search_x_n = 1:searchWindowLengthX
            for search_y_n = 1:searchWindowLengthY
                
                %convert from 1..windowLength to image coordinates
                search_x = ref_x - searchWindowSize(1) + search_x_n - 1;
                search_y = ref_y - searchWindowSize(2) + search_y_n - 1;
                
                %populate support windows with image pixel intensities
                support_right = right_image(...
                    search_x - supportWindowSize(1) : search_x + supportWindowSize(1), ...
                    search_y - supportWindowSize(2) : search_y + supportWindowSize(2));
                
                %Sum of Absolute Differences
                aggregate = sum(sum(abs(support_ref - support_right)));
                
                support_aggregates(search_x_n, search_y_n) = aggregate;
            end
        end
        
        % find the position of the minimum aggregate value in the search window
        [~,xcoords] = min(support_aggregates);
        [minimum,ycoord] = min(min(support_aggregates));
        xcoord = xcoords(ycoord);
        
        % manhattan distance from the corresponding point in the reference image
        disparity = abs(searchWindowMiddleX - xcoord) + abs(searchWindowMiddleX - ycoord);
        
        disparityMap(ref_x, ref_y) = disparity;
        
    end
end

figure;
imagesc(disparityMap);
colormap(gray);
hold on;

figure;
imshow(left_image);
