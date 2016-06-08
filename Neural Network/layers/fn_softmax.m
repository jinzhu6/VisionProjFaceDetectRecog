% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% output: num_nodes x batch_size
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_softmax(input, params, hyper_params, backprop, dv_output)

[num_classes,batch_size] = size(input);
output = zeros(num_classes, batch_size);
% TODO: FORWARD CODE

% y = normalized e^(x)
out = exp(input);
totalOut = sum(out);
output = bsxfun(@rdivide,out,totalOut);

dv_input = [];

% This is included to maintain consistency in the return values of layers,
% but there is no gradient to calculate in the softmax layer since there
% are no weights to update.
grad = struct('W',[],'b',[]); 

if backprop
	dv_input = zeros(size(input));
	% TODO: BACKPROP CODE
    outa = permute(output,[1,3,2]);
    outb = permute(outa,[2,1,3]);
    for i=1:batch_size
        batch = (-outa(:,:,i)*outb(:,:,i)).*~eye(size(input,1),size(input,1));
        mask = (outa(:,:,i)*(1-outb(:,:,i))).*eye(size(input,1),size(input,1));
        multfact = batch+mask;
        dv_input(:,i) = multfact*dv_output(:,i);
    end
end
