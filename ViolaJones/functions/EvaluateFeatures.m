function Features = EvaluateFeatures(All_images, numFaceImages, numBGImages, FP_Index)

global s
global Face_features
global BG_features

%This can be modified to only calculate features for the nonface images, as
%the face images stay the same from stage to stage

numImages = size(All_images,3);


%Calculate features for face images
%Do this only once, since they are the same through all the stages

if s==1
    
    % allfilter_locs = cell(5,1);
    filt_type1_FI = zeros(43200,numFaceImages);
    filt_type2_FI = zeros(43200,numFaceImages);
    filt_type3_FI = zeros(27600,numFaceImages);
    filt_type4_FI = zeros(27600,numFaceImages);
    filt_type5_FI = zeros(20736,numFaceImages);
    
    for i=1:numFaceImages
        results = applyFiltersConv(All_images(:,:,i));
        filt_type1_FI(:,i) = results{1}';
        filt_type2_FI(:,i) = results{2}';
        filt_type3_FI(:,i) = results{3}';
        filt_type4_FI(:,i) = results{4}';
        filt_type5_FI(:,i) = results{5}';
    end
    
    
    Face_features = [filt_type1_FI; filt_type2_FI; filt_type3_FI; filt_type4_FI; filt_type5_FI];
    
    %Calculate features for background images
    filt_type1_BI = zeros(43200,numBGImages);
    filt_type2_BI = zeros(43200,numBGImages);
    filt_type3_BI = zeros(27600,numBGImages);
    filt_type4_BI = zeros(27600,numBGImages);
    filt_type5_BI = zeros(20736,numBGImages);
    
    
    
    for i=1:numBGImages
        results = applyFiltersConv(All_images(:,:,i));
        filt_type1_BI(:,i) = results{1}';
        filt_type2_BI(:,i) = results{2}';
        filt_type3_BI(:,i) = results{3}';
        filt_type4_BI(:,i) = results{4}';
        filt_type5_BI(:,i) = results{5}';
    end
    
    BG_features = [filt_type1_BI; filt_type2_BI; filt_type3_BI; filt_type4_BI; filt_type5_BI];
    
else
    BG_features = BG_features(:,FP_Index);
end





%Put together all features
Features = [Face_features BG_features];