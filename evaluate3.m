support_cmp_name = 'support_cmp_sadct';
refined_result_name = strcat(support_cmp_name, "refined");
results_table.(support_cmp_name) = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1);
times_table.(refined_result_name) = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);
% SAD + CT
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(slide_length, support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = time;
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(refined_disp_map, ground_truth, occlusion_mask);
            end
        end
    end
end


support_cmp_name = 'support_cmp_meanct';
refined_result_name = strcat(support_cmp_name, "refined");
results_table.(support_cmp_name) = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1);
times_table.(refined_result_name) = zeros(search_x_max + 1, search_y_max + 1, support_x_max + 1, support_y_max + 1, methodCount);
% Mean CT
for search_size_x = search_x_min:search_x_max
    for search_size_y = search_y_min:search_y_max
        for support_size_x = support_x_min:support_x_max
            for support_size_y = support_y_min:support_y_max
                
                % compute disp map
                [disp_map, time, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit] = image_disp(slide_length, support_cmp_name, left_image, right_image, search_size_x, search_size_y, support_size_x, support_size_y);
                results_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(disp_map, ground_truth, occlusion_mask);
                times_table.(support_cmp_name)(search_size_x, search_size_y, support_size_x, support_size_y) = time;
                
                % refine
                refined_disp_map = refine_disp_map(refinement_max_iter, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);
                results_table.(refined_result_name)(search_size_x, search_size_y, support_size_x, support_size_y) = evaluate(refined_disp_map, ground_truth, occlusion_mask);
            end
        end
    end
end