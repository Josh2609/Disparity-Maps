refined_disp_map = refine_disp_map(3, disp_map, xLowerLimit, xUpperLimit, yLowerLimit, yUpperLimit);

figure;
imshow(left_image);
hold on;

figure;
imagesc(disp_map);
colormap(gray);
colorbar
hold on;

figure;
imagesc(refined_disp_map);
colormap(gray);
colorbar
hold on;
