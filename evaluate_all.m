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

search_x_min = 1;
search_x_max = 15;

search_y_min = 1;
search_y_max = 3;

support_x_min = 1;
support_x_max = 3;

support_y_min = 1;
support_y_max = 3;

refinement_max_iter = 3;

methodCount = 100;

%results_table = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);
%times_table = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);


support_cmp_name = 'support_cmp_sad';
refined_result_name = strcat(support_cmp_name, "refined");

results_table.(support_cmp_name) = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1);
times_table.(refined_result_name) = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);

% SAD
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
            end
        end
    end
end


support_cmp_name = 'support_cmp_ssd';
% SSD
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
            end
        end
    end
end


support_cmp_name = 'support_cmp_nssd';
% NSSD
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
            end
        end
    end
end


support_cmp_name = 'support_cmp_ct';
% CT
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
            end
        end
    end
end


support_cmp_name = 'support_cmp_sadct';
% SAD + CT
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
            end
        end
    end
end


support_cmp_name = 'support_cmp_meanct';
% Mean CT
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                
            end
        end
    end
end

