function [Weak_theta, Weak_pol, Alpha, WeakClassifiers, weights] = AdaBoost_new(All_features, Labels, numFaceImages,numBgImages, numPrevWC, weights)

%Input is a set of positive (faces) and negative (non-faces) images with
%labels 1 and -1, respectively.

% l = 100; %Number of face images in training set
% m = 400; %Number of nonface images in training set

%Initialize weights as follows
% Weights for face images = 1/(2l)
% Weights for nonface images = 1/(2m)


if numPrevWC ==0
    weights = [ones(1,numFaceImages)./(2*numFaceImages) ones(1,numBgImages)./(2*numBgImages)];
end

%T is the number of feature that I want to have at the end
%T number of weak classifiers that form a strong classifier

%This will go inside of the loop, as described in the paper.

error = zeros(1,size(All_features,1));

% for t=1:numWeakClass
    
    %1. Normalize all weights, such that they al sum to one
    weights = weights./sum(weights);
    
    %2. Apply each feature to each image in the training set
    %This is being ran above to find all features for all images
    %We have determined that thhis needs to be ran only once per stage, or
    %every time a strong classifier is being built.
    
    for i=1:size(All_features,1)
        
        % Determine the threshold to be used and the polarity
        [theta(i), polarity(i)] = threshold(weights, Labels, All_features(i,:));
        
        %Now using this threshold, evaluate the all the features to
        %determine faces and nonfaces
        
        %Evaluate h using threshold and polarity
        if polarity(i) == 1
            h = (All_features(i,:) > theta(i));
        else
            h = (All_features(i,:) < theta(i));
        end
        
        %Record the error for this feature
        error(i)= sum(weights.*abs(h-Labels));
        
    end

    %Determine the minimum error for all the features
    %This will give us the weak classifier
    [minError, WeakClassifiers] = min(error);
    
    %Store the information needed for this weak classifier    
    Weak_theta = theta(WeakClassifiers);
    Weak_pol = polarity(WeakClassifiers);
    weak_error = minError;
    Beta = minError/(1 - minError);
    
    %Determine how many images were classified correctly
    if Weak_pol == 1
        h = (All_features(WeakClassifiers,:) > Weak_theta);
    else
        h = (All_features(WeakClassifiers,:) < Weak_theta);
    end
    
    correct = sum(h==Labels);
    e = (h~=Labels);

    
    %Update Weights for next weak classifier
    weights = weights.*Beta.^(1-e);
    
%     filter(:,:,t) = filterOnly(getfield(Index,'filter_type',{weakClassifiers(t),1}),Index(weakClassifiers(t)).filter_size,getfield(Index,'start_index',{weakClassifiers(t),1}));
    
% end

Alpha = log(1./Beta);