function disparity_map = DisparityCalc(slide_length, support_cmp_name, left_image_path, right_image_path, supp_x, supp_y, search_x, search_y, refinement, refinement_iterations)

f = waitbar(0,'Please wait...');
pause(.5)

addpath('./images');

% Load images
left_image = load_image_gs(left_image_path);
right_image = load_image_gs(right_image_path);

waitbar((0.1),f,'Calculating Disparities... ');
% compute disparity map
[disparity_map, ~, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] ...
    = image_disp(slide_length, support_cmp_name, left_image, right_image, search_x, search_y, supp_x, supp_y);


waitbar((0.8),f,'Finishing Disparity Map... ');
if (refinement == 1)
    % refine for smoothness while penalising changes as well
    disparity_map = refine_disp_map(refinement_iterations, disparity_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
end
close(f);

