function imageSegment(image)

%% Load Photo & Convert to double

% image = imread('Pictures/Class/IMG_0587.jpg');
orig_photo = imresize(image, .3);
photo_rgb = double(orig_photo);

%% Convert into YCbCr coordinates
totalcoords = size(photo_rgb,1)*size(photo_rgb,2);
photo_ycbcr = reshape(reshape(photo_rgb,[totalcoords 3])*...
    [0.257,0.148,0.439;...
    0.504,-.291,-.368;...
    .098,.439,-.071] ...
    +repmat([16,128,128],totalcoords,1), size(photo_rgb));
% imshow(uint8(photo_ycbcr));

%% Find locations of Skin Segments
% Thresholds------------------------------------------------------------------------------------
Cb_threshlow = 150;
Cb_threshhigh = 185;
Cr_threshlow = 150;
Cr_threshhigh = 165;

filtered = (((Cb_threshlow < photo_ycbcr(:,:,2)) .* (photo_ycbcr(:,:,2) < Cb_threshhigh)) ...
    .* ((Cr_threshlow < photo_ycbcr(:,:,3)) .* (photo_ycbcr(:,:,3) < Cr_threshhigh)));
skinCoords_indices = repmat(filtered,1,1,3);
photo_ycbcr_aft = photo_ycbcr.*skinCoords_indices;

new_photo = uint8(255*(photo_rgb.*skinCoords_indices > 0));
% figure;
% imshow(new_photo);

%% Perform Binary Morphological Operations to get rid of background noise
photo_bw = (rgb2gray(new_photo) > 0);

se_erode = strel('disk',1); %-------------------------------------------------------------------
se_dilate = strel('disk',10); %------------------------------------------------------------------

eroded_bw = imerode(photo_bw,se_erode);

% figure;
% imshow(uint8(255*eroded_bw));

dilated_bw = imdilate(eroded_bw,se_dilate);

% figure;
% imshow(uint8(255*dilated_bw));

% Apply Blob Detector
blobs = detectBlobsScaleFilter(dilated_bw, 5, 90, 0.225, 155, .97^3); %-------------------------------------

% Draw blobs on the image (Number of students expected
numBlobs_limit = 20;
rankedblobs = drawBlobs(uint8(photo_ycbcr), blobs, numBlobs_limit);

%% Extract Blobs
% Only use the top blobs
extractedIm = cell(1,numBlobs_limit);
for i=1:size(rankedblobs,1)
    %%
    topb = (rankedblobs(i,2)-ceil(rankedblobs(i,3)));
    botb = (rankedblobs(i,2)+ceil(rankedblobs(i,3)));
    leftb = (rankedblobs(i,1)-ceil(rankedblobs(i,3)));
    rightb = (rankedblobs(i,1)+ceil(rankedblobs(i,3)));
    
    if topb<1
        topb = 1;
    end
    if botb>size(orig_photo,1)
        botb = size(orig_photo,1);
    end
    if leftb<1
        leftb = 1;
    end
    if rightb>size(orig_photo,2)
        rightb = size(orig_photo,2);
    end
    
    photo_rgb_2nd{i} = photo_rgb(topb:botb,leftb:rightb,:);
    photo_ycbcr_2nd{i} = photo_ycbcr(topb:botb,leftb:rightb,:);
%     figure;
%     imshow(uint8(photo_ycbcr_2nd{i}));
    %% Find locations of Skin Segments
    % Thresholds------------------------------------------------------------------------------------
    Cb_threshlow = 150;
    Cb_threshhigh = 185;
    Cr_threshlow = 150;
    Cr_threshhigh = 165;
    
    filtered_2nd{i} = (((Cb_threshlow < photo_ycbcr_2nd{i}(:,:,2)) .* (photo_ycbcr_2nd{i}(:,:,2) < Cb_threshhigh)) ...
        .* ((Cr_threshlow < photo_ycbcr_2nd{i}(:,:,3)) .* (photo_ycbcr_2nd{i}(:,:,3) < Cr_threshhigh)));
    skinCoords_indices_2nd{i} = repmat(filtered_2nd{i},1,1,3);
    photo_ycbcr_aft_2nd{i} = photo_ycbcr_2nd{i}.*skinCoords_indices_2nd{i};
    
    new_photo = uint8(photo_rgb_2nd{i}.*skinCoords_indices_2nd{i});
%     figure
%     imshow(uint8(255*new_photo));
    
    %% Perform Binary Morphological Operations to get rid of background noise
    photo_bw = (rgb2gray(new_photo) > 0);
%     figure
%     imshow(uint8(255*photo_bw));
    
    se_erode = strel('disk',1); %-------------------------------------------------------------------
    se_dilate = strel('disk',10); %------------------------------------------------------------------
    
    eroded_bw = imerode(photo_bw,se_erode);
    
%     figure;
%     imshow(uint8(255*eroded_bw));
    
    dilated_bw = imdilate(eroded_bw,se_dilate);
    
%     figure;
%     imshow(uint8(255*dilated_bw));
    
    %% Extract the Image
    % Apply Blob Detector
    blobs = detectBlobsScaleFilter(dilated_bw, 5, 75, 0.225, 155, .95^3); %-------------------------------------
    
    % Draw blobs on the image (Number of students expected
    numBlobs_limit = 1;
    rankedblobs2 = drawBlobs(uint8(photo_rgb_2nd{i}), blobs, numBlobs_limit);
    
    for j=1:numBlobs_limit
        %%
        topb2 = (rankedblobs2(j,2)-ceil(rankedblobs2(j,3)));
        botb2 = (rankedblobs2(j,2)+ceil(rankedblobs2(j,3)));
        leftb2 = (rankedblobs2(j,1)-ceil(rankedblobs2(j,3)));
        rightb2 = (rankedblobs2(j,1)+ceil(rankedblobs2(j,3)));
        
        if topb2<1
            topb2 = 1;
        end
        if botb2>size(photo_rgb_2nd{i},1)
            botb2 = size(photo_rgb_2nd{i},1);
        end
        if leftb2<1
            leftb2 = 1;
        end
        if rightb2>size(photo_rgb_2nd{i},2)
            rightb2 = size(photo_rgb_2nd{i},2);
        end
        
        photo_rgb_3rd{j} = photo_rgb_2nd{i}(topb2:botb2,leftb2:rightb2,:);
        photo_ycbcr_3rd{j} = photo_ycbcr_2nd{i}(topb2:botb2,leftb2:rightb2,:);
        
        figure;
        imshow(uint8(photo_rgb_3rd{j}));
        
    end
end
end