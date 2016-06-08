%% Pass image through Strong Classifier
orig_image = imread('IMG_0587.jpg');
image = double(rgb2gray(orig_image))/255;

%% Need to segment into smaller sub-images
% Start with images of size 100x100 and then scale up to 1000x1000 in steps
% of 1.25

imgfilt_size = 100;

% Array of location of subimgs and size that passed all Strong Classifiers
subimgs_passed = {};

% Stride of 50
while (imgfilt_size < min(size(image)))
    for i=1:50:(size(image,1)-imgfilt_size+1)
        for j=1:50:(size(image,2)-imgfilt_size+1)
            subimg = image(i:(i+imgfilt_size-1),j:(j+imgfilt_size-1));
            imshow(uint8(255*subimg));
            scaled_subimg = imresize(subimg, [24 24]);
            
            % Pass through Strong Classifiers
            isface = applyClassification(subimg,strongClassifiers);
            if (isface)
                subimgs_passed{end+1} = [i j imgfilt_size imgfilt_size];
            end
            
        end
    end
    imgfilt_size = imgfilt_size*1.25;
end

%% Draw Rectangles
% End result located in subimgs_passed which contains location of face
% start and size of the face box.
hold on
imshow(orig_image);
for face_dims=1:size(subimgs_passed,2)
    dims = subimgs_passed{face_dims};
    rectangle('position',dims,'edgecolor','r','LineWidth',1)
end;
