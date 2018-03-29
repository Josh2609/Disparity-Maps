function aggregate = support_cmp_meanct(support_ref, support_right)

middleX = floor(size(support_ref, 1)/2);
middleY = floor(size(support_ref, 1)/2);

% Mean Census Transform
ref_census = zeros(numel(support_ref), 1);
right_census = zeros(numel(support_right), 1);

mean_ref = mean(mean(support_ref));
mean_right = mean(mean(support_right));

% fill vectors with 0s and 1s 
count = 1;
for x = 1:size(support_ref, 1)
    for y = 1:size(support_ref, 2)
            ref_census(count) = support_ref(x,y) > mean_ref;
            right_census(count) = support_right(x,y) > mean_right;
            count = count + 1;
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