% Convolutional Neural Network to identify identity of face

%%
clear
close all
clc

%Load Training Set Data
ReadImagesidentify;

%%
%Define Training Input
training_input = train_data;
training_labels = train_label;

%Deine Test Input
test_input = test_data;
test_labels = test_label;


%Training input size
train_input_size = size(training_input);
train_batch_size = train_input_size(4);

%Test input size
test_input_size = size(test_input);
test_batch_size = test_input_size(4);


addpath layers;

%Definition of layers

% %12 net
% 
% %Input image 12 x 12 x 3 (RGB)
% 
% 
% %Definition of layers in neural network
% layers = [ ...
% % Convolutional layers with 16 3-by-3 filters with stride 1
%     init_layer('conv',struct('filter_size',3,'filter_depth',3,'num_filters',16)) % We get a 9-by-9-by-16
%     
%  % Max Pooling with 3 by 3 kernel stride 2   
%     init_layer('pool',struct('filter_size',2,'stride',2)) % 3-by-3-by-16
% 
%     %Fully connected layer
%     init_layer('relu',[])
%     init_layer('flatten',struct('num_dims',4))
%     init_layer('linear',struct('num_in',144,'num_out',2))
%     init_layer('softmax',[])];
% 
% model = init_model(layers,train_input_size(1:3),10,true);


%Definition of layers in neural network
layers = [ ... // Input 112x92x1x400
    init_layer('flatten',struct('num_dims',4))
    init_layer('linear',struct('num_in',10304,'num_out',40))
    init_layer('softmax',[])];

model = init_model(layers,train_input_size(1:3),40,true);

%Parameters
params.learning_rate = 0.0025;
params.weight_decay = 0.3;
params.batch_size = train_batch_size;

numIters = 250;
loss_total =[];
%%

for i=1:100
    
    tic
    %Train Model for numIters
    [model, loss, loss_t] = train(model,training_input,training_labels,params,numIters);
    toc
    
    loss_total = [loss_total loss_t];
    
    % Test trained model on entire test set
    [output, ~] = inference_(model,test_input);
    [~, obtained_labels] = max(output);
    [TS_loss,~] = loss_crossentropy_(output,test_labels, [], true);
 
    correct = sum(obtained_labels' == test_labels);
    
    TS_loss_total(i) = TS_loss
    percentage_correct(i) = correct/test_batch_size
    
end

%%
figure (1);
plot(loss_total);
title('Loss vs. Training Iterations - Training Set')
xlabel('Iterations')
ylabel('Loss')

figure (2);
plot([numIters:numIters:i*numIters],TS_loss_total, '*')
title('Loss vs. Training Iterations - Test Set')
xlabel('Iterations')
ylabel('Percent correct')

figure (3);
plot([numIters:numIters:i*numIters],percentage_correct*100, '*')
title('Percent Correct vs. Training Iterations - Test Set')
xlabel('Iterations')
ylabel('Percent correct')

%%
save('faceidentify.mat','model','i','numIters','loss_t','loss_total','percentage_correct','TS_loss_total')
