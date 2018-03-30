addpath('./images');

% Specify comparison method
support_cmp_name = 'support_cmp_meanct';

% Load images
left_image = load_image_gs('images/scene_l.bmp');
right_image = load_image_gs('images/scene_r.bmp');

search_size_x = 15;
search_size_y = 2;

support_size_x = 4;
support_size_y = 4;

slide_length = 1;

refinement_max_iter = 0;

% compute disparity map
[disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] ...
    = image_disp(slide_length, support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);

% refine for smoothness while penalising changes as well
refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);

% reference
figure;
imshow(left_image);
hold on;

% unrefined disparity
figure;
imagesc(disp_map);
colormap(gray);
colorbar
hold on;

% refined disparity
figure;
imagesc(refined_disp_map);
colormap(gray);
colorbar
hold on;