function [template] = filterOnly(filter_type,filter_size,start_index)
template = zeros(24,24);
 
feature_types = {[-1 1], [1; -1], [-1 1 -1], [-1; 1; -1], [-1 1; 1 -1]};
filt = imresize(feature_types{filter_type},[filter_size(1) filter_size(2)], 'nearest');
[xloc, yloc] = ind2sub([(24-filter_size(1)+1) (24-filter_size(2)+1)], start_index);
 
template(xloc:(xloc+filter_size(1)-1),yloc:(yloc+filter_size(2)-1)) = filt;