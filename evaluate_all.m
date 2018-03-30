%evaluate all methods on the tsukuba images

left_image = imread('images/scene_l.bmp');
right_image = imread('images/scene_r.bmp');

% Check if images are greyscale and if not, convert them.
if size(left_image,3) == 3
    left_image = rgb2gray(left_image);
end
if size(right_image,3) == 3
    right_image = rgb2gray(right_image);
end

addpath('./images');
ground_truth = imread('images/tsukuba_groundtruth.png');
occlusion_mask = imread('images/tsukuba_occlusion.png');

search_x_min = 15;
search_x_max = 15;

search_y_min = 2;
search_y_max = 2;

support_x_min = 4;
support_x_max = 4;

support_y_min = 4;
support_y_max = 4;

refinement_max_iter = 0;
slide_length = 1;

methodCount = 100;

%results_table = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);
%times_table = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);

evaluate1;
evaluate2;
evaluate3;







