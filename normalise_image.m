function scaled_disp_map = normalise_image(disp_map)

disp_map = double(disp_map);

% scale maps so they are comparable
max_disp = max(unique(disp_map));
min_disp = min(unique(disp_map));

newMin = 0;
newMax = 255;

scaled_disp_map = zeros(size(disp_map, 1), size(disp_map, 2));

for x = 1:size(disp_map, 1)
    for y = 1:size(disp_map, 2)
        scaled_disp_map(x,y) = map(disp_map(x,y), min_disp, max_disp, newMin, newMax);
    end
end

end

function value = map(val, old_min, old_max, new_min, new_max)

value = new_min + (new_max - new_min) * ((val - old_min) / (old_max - old_min));

end