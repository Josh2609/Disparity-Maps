% load greyscale image
function image = load_image_gs(path)

image = imread(path);

% Check if images are greyscale and if not, convert them.
if size(image,3) == 3
    image = rgb2gray(image);
end

end