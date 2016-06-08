% ----------------------------------------------------------------------
% input: num_nodes x batch_size
% labels: batch_size x 1
% ----------------------------------------------------------------------

function [loss, dv_input] = loss_crossentropy(input, labels, hyper_params, backprop)

assert(max(labels) <= size(input,1));

% TODO: CALCULATE LOSS
% y = full(sparse(labels, 1:size(input,2), 1));
I = sub2ind(size(input), labels', 1:size(input,2));
y = input(I);
loss = -mean(log(y));

dv_input = [];
if backprop
	% TODO: BACKPROP CODE
    % dL/dx = -1/xj

    dv_input = zeros(size(input));
    dx = -(1/size(input,2))./(input);
    dv_input(I) = dx(I);

end
