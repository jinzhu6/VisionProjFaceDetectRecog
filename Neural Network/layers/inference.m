function [output,activations] = inference(model,input)
% Do forward propagation through the network to get the activation
% at each layer, and the final output

num_layers = numel(model.layers);
activations = cell(num_layers,1);

% TODO: FORWARD PROPAGATION CODE


int_input = input;
for i =1: num_layers
%     curr_layer_type = model.layers(i).type;
    
    [activations{i},~,~] = feval(model.layers(i).fwd_fn, int_input, model.layers(i).params, model.layers(i).hyper_params, 0, []);
    int_input = activations{i};
    
%     @fn_conv(input, params, hyper_params, backprop, dv_output)
end

output = activations{end};
