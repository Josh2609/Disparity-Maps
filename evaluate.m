function result = evaluate(disp_map, ground_truth, occlusion_mask)

disp_map = double(disp_map);
ground_truth = double(ground_truth);
occlusion_mask = double(occlusion_mask);

% scale maps so they are comparable
max_disp = max(unique(disp_map));
min_disp = min(unique(disp_map));

max_truth = max(unique(ground_truth));
min_truth = min(unique(ground_truth));

newMin = 0;
newMax = 255;

scaled_disp_map = zeros(size(disp_map, 1), size(disp_map, 2));
scaled_ground_truth = scaled_disp_map;
differences = scaled_disp_map;

for x = 1:size(disp_map, 1)
    for y = 1:size(disp_map, 2)
        scaled_disp_map(x,y) = map(disp_map(x,y), min_disp, max_disp, newMin, newMax);
        scaled_ground_truth(x,y) = map(ground_truth(x,y), min_truth, max_truth, newMin, newMax);
    end
end

unoccluded_pixel_count = 0;
for x = 1:size(occlusion_mask, 1)
    for y = 1:size(occlusion_mask, 2)
        %ignore difference if pixel is occluded
        if (occlusion_mask(x, y) == 0)
            difference = 0;
        else
            difference = scaled_disp_map(x, y) - scaled_ground_truth(x, y);
            difference = abs(difference);
            unoccluded_pixel_count = unoccluded_pixel_count + 1;
        end
        differences(x, y) = difference;
    end
end

result = sum(sum(differences)) / unoccluded_pixel_count;

end

function value = map(val, old_min, old_max, new_min, new_max)

value = new_min + (new_max - new_min) * ((val - old_min) / (old_max - old_min));

end