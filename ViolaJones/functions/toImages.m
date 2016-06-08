% Given 1000 images, apply the filter to all the images
clc
clear
close all


tic;
numImages = 100;
setofImages = cell(numImages,1);
for j = 1:numImages
    setofImages{j} = randi(255, 24, 24);
end

% For all of the images, apply filters
% For each filter, 1:43200, 2:43200, 3:27600, 5:27600, 6:20736
allfilter_locs = cell(5,1);
filt_type1 = zeros(43200,numImages);
filt_type2 = zeros(43200,numImages);
filt_type3 = zeros(27600,numImages);
filt_type4 = zeros(27600,numImages);
filt_type5 = zeros(20736,numImages);

for i=1:size(setofImages,1)
    results = applyFiltersConv(setofImages{i});
    filt_type1(:,i) = results{1};
    filt_type2(:,i) = results{2};
    filt_type3(:,i) = results{3};
    filt_type4(:,i) = results{4};
    filt_type5(:,i) = results{5};
end
toc;
disp('done!');