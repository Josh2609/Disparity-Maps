% load greyscale image
function image = load_image_gs(path)

[image, cmap] = imread(path);

for x = 1:size(image, 1)
    for y = 1:size(image, 2)
        image(x,y) = floor(255*cmap(image(x,y)+1));
    end
end


end