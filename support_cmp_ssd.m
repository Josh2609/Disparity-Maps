function aggregate = support_cmp_ssd(support_ref, support_right)

%Sum of Squared Differences
support_right = support_right - mean_right;
support_ref = support_ref - mean_ref;
aggregate = sum(sum((support_ref - support_right).^2));

end