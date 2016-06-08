function [index] = getIndex(~)
image = randi(255, 24, 24);
feature_types = {[-1 1], [1; -1], [-1 1 -1], [-1; 1; -1], [-1 1; 1 -1]};
feature_size = {43200, 43200, 27600, 27600, 20736};
frameSize = 24;
num_features = 5;

resultsfilttype = zeros(162336,1);
resultsfilttype(1:43200) = 1; resultsfilttype(43201:86400) = 2; resultsfilttype(86401:114000) = 3; 
resultsfilttype(114001:141600) = 4; resultsfilttype(141601:162336) = 5;  

loc = 1;
resultsfilt_size = cell(162336,1);
resultsstart_index = zeros(162336,1);
results_values = zeros(162336,1);
%Now, we iterate through all the features
for i=1:num_features
    feature = feature_types{i};
    %Determine the sizes of the current feature
    sizeX = size(feature,2); %Width
    sizeY = size(feature,1); %Height
    
    heightdir = ((frameSize-sizeY)/sizeY)+1;
    widthdir = ((frameSize-sizeX)/sizeX)+1;
    
    %Change the width and the height of the filter
    for width = 1:widthdir %Change the width
        for height = 1:heightdir %Change the width
            act_width = width*sizeX;
            act_height = height*sizeY;
            
            filt = imresize(feature,[act_height act_width], 'nearest');
            img_conv = conv2(image, filt, 'valid');
            results_values(loc:(loc+size(img_conv(:))-1)) = img_conv(:);
            resultsfilt_size(loc:(loc+size(img_conv(:))-1)) = {[act_height act_width]};
            resultsstart_index(loc:(loc+size(img_conv(:))-1)) = 1:(size(img_conv(:)));
            
            loc = loc+size(img_conv(:),1);
        end
    end
end
index = struct('filter_type',resultsfilttype,'filter_size',resultsfilt_size,'start_index',resultsstart_index);