function aggregate = support_cmp_ct(support_ref, support_right)

middleX = floor(size(support_ref, 1)/2);
middleY = floor(size(support_ref, 1)/2);

% Census Transform
ref_census = zeros(numel(support_ref) - 1, 1);
right_census = zeros(numel(support_right) - 1, 1);

% fill vectors with 0s and 1s 
count = 1;
for x = 1:size(support_ref, 1)
    for y = 1:size(support_ref, 2)
        if ~(x == middleX && y == middleY)
            ref_census(count) = support_ref(x,y) > support_ref(middleX, middleY);
            right_census(count) = support_right(x,y) > support_right(middleX, middleY);
            count = count + 1;
        end
    end
end

% get the hamming distance (number of values that differ)
hamming_dist = 0;
for i = 1:size(ref_census,1)
    if (ref_census(i) ~= right_census(i))
        hamming_dist = hamming_dist + 1;
    end
end

aggregate = hamming_dist;

end