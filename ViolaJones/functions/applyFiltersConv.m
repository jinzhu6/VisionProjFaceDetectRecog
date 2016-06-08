% image = randi(255, 24, 24);
function [results] = applyFiltersConv(image)

feature_types = {[-1 1], [1; -1], [-1 1 -1], [-1; 1; -1], [-1 1; 1 -1]};
feature_size = {43200, 43200, 27600, 27600, 20736};
frameSize = 24;
num_features = 5;

results = cell(5,1);

%Now, we iterate through all the features
for i=1:num_features
    feature = feature_types{i};
    %Determine the sizes of the current feature
    sizeX = size(feature,2); %Width
    sizeY = size(feature,1); %Height
    
    %Now, we apply this feature to the image by doing something similar to
    %convolution and changing its sizes
    
%     final_filtered = cell(((frameSize-sizeY)/sizeY)+1,((frameSize-sizeX)/sizeX)+1);
    
    heightdir = ((frameSize-sizeY)/sizeY)+1;
    widthdir = ((frameSize-sizeX)/sizeX)+1;
    
    loc = 1;
    final_filt = zeros(feature_size{i},1);
    
    %Change the width and the height of the filter
    for width = 1:widthdir %Change the width
        for height = 1:heightdir %Change the width
            act_width = width*sizeX;
            act_height = height*sizeY;
            
            
%             final_filtered(1,height,width) = {[act_width, act_height]};
            
            filt = imresize(feature,[act_height act_width], 'nearest');
%             final_filtered{height,width} = conv2(image, filt, 'valid');
            img_conv = conv2(image, filt, 'valid');
            final_filt(loc:(loc+size(img_conv(:))-1)) = img_conv(:);
            loc = loc+size(img_conv(:),1);
            
            %Now we slide the filter around the image and calculate its
            %output.
            %This could be done with convolution

            
%             for x=1:frameSize - act_width + 1
%                 for y=1:frameSize - act_height + 1;
%                     %Now, we evaluate the current filter in the image
%                     %declare filter
%                     
%                     
%                     
%                     %Need to finish this
%                     count = count+1;
%                 end
%             end
        end
    end
    results(i) = {final_filt};
%     disp(count);
end