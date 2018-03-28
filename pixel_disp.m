function [match_coords, minimum, disparity] = pixel_disp(ref_x, ref_y, searchWindowSize, supportWindowSize, left_image, right_image, support_cmp_name)

searchWindowLengthX = 2*searchWindowSize(1) + 1;
searchWindowLengthY = 2*searchWindowSize(2) + 1;

searchWindowMiddleX = searchWindowSize(1) + 1;
searchWindowMiddleY = searchWindowSize(2) + 1;

support_cmp_handle = str2func(support_cmp_name);

% matrix to hold the aggregated values from each support window
support_aggregates = zeros(searchWindowLengthX, searchWindowLengthY);

for search_x_n = 1:searchWindowLengthX
    for search_y_n = 1:searchWindowLengthY

        %convert from 1..windowLength to image coordinates
        search_x = ref_x - searchWindowSize(1) + search_x_n - 1;
        search_y = ref_y - searchWindowSize(2) + search_y_n - 1;

        %populate support windows with image pixel intensities
        %convert to single to allow negative values
        %recalculate reference support window since it might be changed
        support_ref = single(left_image(...
            ref_x - supportWindowSize(1) : ref_x + supportWindowSize(1), ...
            ref_y - supportWindowSize(2) : ref_y + supportWindowSize(2)));

        support_right = single(right_image(...
            search_x - supportWindowSize(1) : search_x + supportWindowSize(1), ...
            search_y - supportWindowSize(2) : search_y + supportWindowSize(2)));

        %aggregate = support_cmp_nssd(support_ref, support_right);
        aggregate = support_cmp_handle(support_ref, support_right);
        
        support_aggregates(search_x_n, search_y_n) = aggregate;
    end
end

% find the position of the minimum aggregate value in the search window
[~,xcoords] = min(support_aggregates);
[minimum,ycoord] = min(min(support_aggregates));
xcoord = xcoords(ycoord);

% distance from the corresponding point in the reference image
relativePosition = [(searchWindowMiddleX - xcoord) (searchWindowMiddleY - ycoord)];
positions = [relativePosition; 0 0];
match_coords = [ref_x ref_y] + relativePosition;
disparity = pdist(positions, 'euclidean');



end