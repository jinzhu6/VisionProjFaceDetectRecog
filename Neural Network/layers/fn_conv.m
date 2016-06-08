% ----------------------------------------------------------------------
% input: in_height x in_width x num_channels x batch_size
% output: out_height x out_width x num_filters x batch_size
% hyper parameters: (stride, padding for further work)
% params.W: filter_height x filter_width x filter_depth x num_filters
% params.b: num_filters x 1
% dv_output: same as output
% dv_input: same as input
% grad.W: same as params.W
% grad.b: same as params.b
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_conv(input, params, hyper_params, backprop, dv_output)

[~,~,num_channels,batch_size] = size(input);
[~,~,filter_depth,num_filters] = size(params.W);
assert(filter_depth == num_channels, 'Filter depth does not match number of input channels');

out_height = size(input,1) - size(params.W,1) + 1;
out_width = size(input,2) - size(params.W,2) + 1;
output = zeros(out_height,out_width,num_filters,batch_size);


% TODO: FORWARD CODE
for b=1:batch_size
    for i=1:num_filters
        for j=1:filter_depth
            output(:,:,i,b) = output(:,:,i,b) + conv2(input(:,:,j,b),params.W(:,:,j,i),'valid');
        end
        output(:,:,i,b) = output(:,:,i,b) + repmat(params.b(i),size(output,1),size(output,2));
    end
end

dv_input = [];
grad = struct('W',[],'b',[]);

if backprop
	dv_input = zeros(size(input));
	grad.W = zeros(size(params.W));
	grad.b = zeros(size(params.b));
    
	% TODO: BACKPROP CODE
    
    % dL/dx = dL/dy * dy/dx
    for b=1:batch_size
        for i=1:num_filters
            for j=1:filter_depth
                dv_input(:,:,j,b) = dv_input(:,:,j,b) + conv2(dv_output(:,:,i,b),rot90(params.W(:,:,j,i),2));
                grad.W(:,:,j,i) = grad.W(:,:,j,i) + conv2(input(:,:,j,b),rot90(dv_output(:,:,i,b),2),'valid');
            end
            grad.b(i,:) = grad.b(i,:) + sum(sum(dv_output(:,:,i,b)));
        end
    end
    
    grad.W = rot90(grad.W,2);
end
