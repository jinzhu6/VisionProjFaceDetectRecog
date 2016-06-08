function [DetectionRate, FalsePosRate, FP_Index] = EvaluateClassifier(All_images, numFaceImages, numBgImages, Labels, weakClassifiers, alpha, weak_theta, weak_pol, threshold)
%This function evaluates the classifier on the dataset as given in
%All_Images. It determines detection and false positive rates. 


Index=getIndex;
numWeakClass = length(weakClassifiers);

for j=1: numWeakClass
        filter(:,:,j) = filterOnly(getfield(Index,'filter_type',{weakClassifiers(j),1}),Index(weakClassifiers(j)).filter_size,getfield(Index,'start_index',{weakClassifiers(j),1}));
end


for i =1:size(All_images,3)
    classifier(i) = 0;
    for j=1: numWeakClass
        if weak_pol(j) ==1 
            classifier(i)=classifier(i) + alpha(j)*(sum(sum(All_images(:,:,i).*filter(:,:,j))) > weak_theta(j));
        else
            classifier(i)=classifier(i) + alpha(j)*(sum(sum(All_images(:,:,i).*filter(:,:,j))) < weak_theta(j));
        end
    end
    
    if classifier(i) >= threshold*sum(alpha)
        labels_detected(i) = 1;
    else
        labels_detected(i) = 0;
    end
    
end

 correct=sum(Labels == labels_detected);

%Determine detection rate and false positives
%Detection rate = number of true faces detected out of all true faces in
%the dataset

DetectionRate = sum(Labels(1:numFaceImages) == labels_detected(1:numFaceImages))/numFaceImages;
FalsePos = Labels(numFaceImages+1:end)~= labels_detected(numFaceImages+1:end);
FalsePosRate = sum(FalsePos)/numBgImages;
FP_Index = find(FalsePos);
