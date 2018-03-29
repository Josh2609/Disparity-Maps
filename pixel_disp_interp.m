function [match_coords, minimum, disparity] = pixel_disp_interp(slide_length, ref_x, ref_y, searchWindowSize, supportWindowSize, left_image, right_image, support_cmp_name)

%use the non-interpolated version if the slide_length is 1
if (slide_length == 1)
            [match_coords, minimum, disparity] = pixel_disp(ref_x, ref_y,...
           searchWindowSize, supportWindowSize,...
           left_image, right_image,...
           support_cmp_name);
       return
end

%searchWindowLengthX = floor ((2*searchWindowSize(1) + 1)/slide_length);
%searchWindowLengthY = floor ((2*searchWindowSize(2) + 1)/slide_length);

searchWindowLengthX = 2*searchWindowSize(1) + 1;
searchWindowLengthY = 2*searchWindowSize(2) + 1;

num_values_x = (1/slide_length)*(searchWindowLengthX - 1) + 1;
num_values_y = (1/slide_length)*(searchWindowLengthY - 1) + 1;

searchWindowMiddleX = ceil(searchWindowLengthX/2);
searchWindowMiddleY = ceil(searchWindowLengthY/2);

supportWindowLengthX = 2*supportWindowSize(1) + 1;
supportWindowLengthY = 2*supportWindowSize(2) + 1;

supportWindowMiddleX = ceil(supportWindowLengthX/2);
supportWindowMiddleY = ceil(supportWindowLengthY/2);

support_cmp_handle = str2func(support_cmp_name);

% matrix to hold the aggregated values from each support window
support_aggregates = zeros(searchWindowLengthX, searchWindowLengthY);

for search_x_n = 0:num_values_x-1
    for search_y_n = 0:num_values_y-1
            
        %convert from 1..windowLength to image coordinates
        search_x = ref_x - searchWindowSize(1) + search_x_n * slide_length;
        search_y = ref_y - searchWindowSize(2) + search_y_n * slide_length;
        
        
        %populate support windows with image pixel intensities
        %convert to single to allow negative values
        %recalculate reference support window since it might be changed
        support_ref = single(left_image(...
            ref_x - supportWindowSize(1) : ref_x + supportWindowSize(1), ...
            ref_y - supportWindowSize(2) : ref_y + supportWindowSize(2)));
        
        start_x = search_x;
        start_y = search_y;
        samples_x = [floor(start_x)];
        % each pixel's value is determined by at most 4 others
        % if x value not on pixel grid (not an integer)
        if ~(mod(search_x,1) == 0)
            samples_x = [samples_x; floor(start_x) + 1];
        end
        %how much of each pixel does the support window cover?
        x_slide = (start_x - floor(start_x));
        x_ratios = [1-x_slide x_slide];


        samples_y = [floor(start_y)];
        if ~(mod(start_y,1) == 0)
            samples_y = [samples_y; floor(start_y) + 1];
        end
        %how much of each pixel does the support window cover?
        y_slide = (start_y - floor(start_y));
        y_ratios = [1-y_slide y_slide];
        
        %make a vector of all pixels to be sampled, along with their weights
        clear sample_points;
        count = 1;
        for x = 1:size(samples_x,1)
            for y = 1:size(samples_y,1)
                weight = x_ratios(x) * y_ratios(y); %area in a 1x1 box will add up to 1, so no need to normalise
                sample_points(count, :, :, :) = [samples_x(x) samples_y(y) weight];
                count = count+1;
            end
        end
        
        support_right = zeros(size(support_ref, 1), size(support_ref, 2));
        
        for sup_x = 0:supportWindowLengthX-1
            for sup_y = 0:supportWindowLengthY-1
                
                intensity = 0;
                for e = 1:size(sample_points,1)
                    this_point = [sample_points(e, 1) + sup_x - supportWindowSize(1) sample_points(e, 2) + sup_y - supportWindowSize(2)];
                    intensity = intensity + right_image(this_point(1), this_point(2)) * sample_points(e, 3);
                    %intensity = intensity + right_image(sample_points(e, 1) + sup_x - supportWindowSize(1), sample_points(e, 2) + sup_y - supportWindowSize(2)) * sample_points(e, 3);
                end
                
                support_right(sup_x+1, sup_y+1) = single(intensity);
            end
        end
        
%         support_right = single(right_image(...
%             search_x - supportWindowSize(1) : search_x + supportWindowSize(1), ...
%             search_y - supportWindowSize(2) : search_y + supportWindowSize(2)));

        %aggregate = support_cmp_nssd(support_ref, support_right);
        aggregate = support_cmp_handle(support_ref, support_right);
        
        support_aggregates(search_x_n+1, search_y_n+1) = aggregate; %+1 because they start from zero
    end
end

% find the position of the minimum aggregate value in the search window
[~,xcoords] = min(support_aggregates);
[minimum,ycoord] = min(min(support_aggregates));
xcoord = xcoords(ycoord);

% distance from the corresponding point in the reference image
position = [(ref_x - searchWindowSize(1) + (xcoord-1) * slide_length) (ref_y - searchWindowSize(2) + (ycoord-1) * slide_length)];
positions = [position; ref_x ref_y];
match_coords = position;
disparity = pdist(positions, 'euclidean');



end

% recursively count the number of points produced by subdividing a line segment of the given number of colinear points
function points = count_subdivisions(subdivisions, undividedpoints)
    if (subdivisions > 0)
        points = count_subdivisions(subdivisions - 1, 2*undividedpoints-1);
    else
        points = undividedpoints;
    end
end

% create a larger image grid, filled with interpolated values from a given
% input grid.
function output_image = interp_image(subdivisions, input_image)
    
    % calculate size after 1 subdivision.
    imageX = count_subdivisions(1, size(image, 1))
    imageY = count_subdivisions(1, size(image, 2))

    output_image = zeros(imageX, imageY);
    % fill in known values
    output_image(1:2:end, 1:2:end) = input_image(:, :); %note: start at 1, skipping every other x and y value with "1:2:end"
    
    % fill midpoints with interpolated values
    for x = 2:2:size(output_image, 1)
        for y = 2:2:size(output_image, 2)
            output_image(x, y) = output_image(x)
        end
    end
end