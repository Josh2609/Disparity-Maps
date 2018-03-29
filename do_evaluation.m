addpath('./images');
ground_truth = imread('images/tsukuba_groundtruth.png');
occlusion_mask = imread('images/tsukuba_occlusion.png');
result = evaluate(disp_map, ground_truth, occlusion_mask);