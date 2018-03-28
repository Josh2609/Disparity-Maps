function aggregate = support_cmp_sad(support_ref, support_right)

%Sum of Absolute Differences
aggregate = sum(sum(abs(support_ref - support_right)));

end