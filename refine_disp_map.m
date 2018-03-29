function disp_map = refine_disp_map(max_iter, unrefined_disp_map, x_start, x_end, y_start, y_end)

% define max iterations in case it never converges or it takes too long
iter = 0;
changed = 1;

disp_map = unrefined_disp_map;

while (iter < max_iter && changed == 1)
    
    
    %update list of potential classifications (disparity levels)
    disp_levels = unique(disp_map);
    
    %store output values in a different map
    disp_map_next = disp_map;
    
    disp_count = size(disp_levels, 1);
    
    for x = x_start:x_end
        for y = y_start:y_end
            
            % remember initial disp
            initial_disp = disp_map(x, y); 
            
            % consider each possible disparity value
            for disp_i = 1:disp_count
                considered_disp = disp_levels(disp_i);
                current_disp = disp_map(x, y);
                current_energy = calc_energy(current_disp, x, y, disp_map, unrefined_disp_map);
                considered_energy = calc_energy(considered_disp, x, y, disp_map, unrefined_disp_map);
                
                %switch if the considered configuration gives lower energy.
                if (considered_energy < current_energy)
                    disp_map(x, y) = considered_disp;
                end
                
            end
            
            % set new value in next map and revert decision before moving on
            disp_map_next(x, y) = disp_map(x, y);
            disp_map(x, y) = initial_disp;
        end
    end
    
    iter = iter + 1;
    if (disp_map == disp_map_next) changed = 0; else changed = 1; end
    disp_map = disp_map_next;
    
    
end

end

function energy = calc_energy(assignment, x, y, disp_map, unrefined_disp_map)

%get neighbour intensities
x_begin = x - 1;
if (x == 1) x_begin = x; end
x_end = x + 1;
if (x == size(disp_map, 1)) x_end = x; end

y_begin = y - 1;
if (y == 1) y_begin = y; end
y_end = y + 1;
if (y == size(disp_map, 1)) y_end = x; end

%neighbour_disps = disp_map(x_indices,y_indices);
%neighbour_disps = disp_map(x_begin:x_end,y_begin:y_end);
neighbour_disps = zeros((x_end-x_begin)*(y_end-y_begin)-1, 1);
count = 1;
for x_i=x_begin:x_end
    for y_i=y_begin:y_end
        if ~(x_i == x && y_i == y)
            neighbour_disps(count) = disp_map(x_i,y_i);
            count = count + 1;
        end
    end
end

unrefined_own_disp = unrefined_disp_map(x, y);

%define data term as distance from the cost obtained by the support_compare
%method
data_term = abs(assignment - unrefined_own_disp);

% define the smoothness term to limit gaps between disparities assigned
smoothness_term = 0;
for i = 1:size(neighbour_disps, 1)
    % l1 norm
    smoothness_term = smoothness_term + abs(assignment - neighbour_disps(i));
end

smoothness_weight = 1.0;

energy = data_term + smoothness_weight * smoothness_term;

end