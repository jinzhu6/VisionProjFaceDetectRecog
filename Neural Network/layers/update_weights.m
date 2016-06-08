function updated_model = update_weights(model,grad, hyper_params)

num_layers = length(grad);
a = hyper_params.learning_rate;
lmda = hyper_params.weight_decay;
% updated_model = model;

% TODO: Update the weights of each layer in your model based on the
% calculated gradients

% batch_size = model.input_size(4);

for i=1: num_layers
    
%     delta_W{i} = size(model.layers(1).params.W)
%     delta_b{i} = size(model.layers(1).params.b)

    if strcmp(model.layers(i).type, 'conv') || strcmp(model.layers(i).type,'linear') 
%         %Perform weights update with momentum
%         %When using velocity we need to keep track of the velocities used
%         in the previous update_weights for each specific layer. This
%         could be added to the model as part of the parameters?

% Weight Update with momentum
          model.layers(i).params.vW = 0.5*model.layers(i).params.vW -  a.*grad{i}.W ;
          model.layers(i).params.W = model.layers(i).params.W  + model.layers(i).params.vW;
          
          model.layers(i).params.vb = 0.5*model.layers(i).params.vb -  a.*grad{i}.b;
          model.layers(i).params.b = model.layers(i).params.b  + model.layers(i).params.vb;

% %         Perform update weights without momentum
%         model.layers(i).params.W = model.layers(i).params.W  - a.*grad{i}.W;
%         model.layers(i).params.b = model.layers(i).params.b  - a.*grad{i}.b;
    end
    
end

updated_model = model;







