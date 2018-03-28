function aggregate = support_cmp_nssd(support_ref, support_right)

%Normalised Sum of Squared Differences
mean_ref = mean(mean(support_ref));
mean_right = mean(mean(support_right));
support_right = support_right - mean_right;
support_ref = support_ref - mean_ref;
aggregate = sum(sum((support_ref - support_right).^2));

end