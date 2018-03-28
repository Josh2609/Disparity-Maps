function aggregate = support_cmp_ssd(support_ref, support_right)

%Sum of Squared Differences
aggregate = sum(sum((support_ref - support_right).^2));

end