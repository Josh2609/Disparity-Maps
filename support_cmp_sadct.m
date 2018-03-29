function aggregate = support_cmp_sadct(support_ref, support_right)

%Sum of Absolute Differences
sad = sum(sum(abs(support_ref - support_right)));

aggregate = sad + support_cmp_ct(support_ref, support_right);

end