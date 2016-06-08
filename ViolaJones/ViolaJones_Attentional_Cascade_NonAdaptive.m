%EECS 442 Project
%Implementation of Viola Jones Algorithm for face detection
%Written by Sahit Bollineni and Juan Orozco

%Tabula Rasa
clear
close all 
clc

%Define Global Variables
global s
global Face_features
global BG_features

%Get Index for all diffferent features 
%This is used to determine the location of the feature in the 24-by-24
%detection window
index=getIndex;

%% Read Training Images

%Specify the number of face images and non face images to read from the
%database
numFaceImages = 200;
numBgImages = 800;
numImages= numBgImages + numFaceImages;

tic
[All_Images, FaceImages, BgImages, Labels] = ReadImages(numFaceImages, numBgImages);
toc

%% Cascade Training Procedure

%Implementation of attentional cascade

%Specify how many weak classifiers per stage
numWCperStage = [2]; % 25 25 30 35];% 7 9 11 13 15 17 20 22];
numStages = length(numWCperStage);

%Initialize struct for storing strong classifiers
StrClass = struct('theta',[], 'polarity', [], 'alpha', [], 'weakClass', [], 'detectionRate', [], 'FP_rate', [], 'Coefficient', []);


%Initialize variables to be used within the loop
Images_CS = All_Images; 
FaceImages_CS = FaceImages;
BgImages_CS = BgImages;
Labels_CS = Labels;
numFI_CS = numFaceImages;
numBI_CS = numBgImages;
FP_Index =[];

for s=1:numStages
    
    % Calculate features for all face and non-face images
    tic
    Features_CS = EvaluateFeatures(Images_CS, numFI_CS, numBI_CS, FP_Index);
    disp(['Features for stage ', num2str(s), ' have been calculated']);
    toc
    
    %Run Adaboost
    [weak_theta, weak_pol, alpha, weakClassifiers] = AdaBoost(Features_CS, Labels_CS, numFI_CS,numBI_CS, numWCperStage(s))
    disp(['Adaboost for stage ', num2str(s), ' has finalized']);

    %Apply Strong Clasifier to determine detection rate,FP, and data for
    %next stage. Modify the threshold used for classification to obtain
    %desired rates. 
    
    DetectionRate = 0;
    Coefficient = 0.5;
    
    while DetectionRate < 0.80 && Coefficient > 0.05
        [DetectionRate, FP_Rate, FP_Index] = EvaluateClassifier(Images_CS, numFI_CS, numBI_CS, Labels_CS, weakClassifiers, alpha, weak_theta, weak_pol, Coefficient)
        Coefficient = Coefficient*0.95;
    end
    
    %Save Data to strong classifiers struct
    StrClass(s).theta = weak_theta;
    StrClass(s).polarity = weak_pol;
    StrClass(s).alpha = alpha;
    StrClass(s).weakClass = weakClassifiers;
    StrClass(s).detectionRate = DetectionRate;
    StrClass(s).FP_rate = FP_Rate;
    StrClass(s).Coefficient = Coefficient;
    
    
    
    %Prepare for next iteration
    FaceImages_CS = FaceImages;
    BgImages_CS = BgImages_CS(:,:,FP_Index);
    Images_CS = cat(3,FaceImages_CS, BgImages_CS); 
    
    numFI_CS = numFaceImages;
    numBI_CS = size(BgImages_CS,3);
    
    Labels_CS = [ones(1,numFI_CS), zeros(1, numBI_CS)];
end

%Store strong classifier in the hard drive for future use
save('StrongClass_4-29','StrClass')

%% Apply filters to a test image to determine results

orig_image = imread('test3.jpg');
image = double(rgb2gray(orig_image))/255;
image = (image - mean(image(:)))./std(image(:));

%Scan image to determine if subwindows are faces or not. 

% Start with images of size 100x100 and then scale up to 1000x1000 in steps
% of 1.25

index=getIndex;

imgfilt_size = 5;
stride = 5;
max_filt_size = ceil(min(size(image))/4);

% Array of location of subimgs and size that passed all Strong Classifiers
subimgs_passed = {};

% Stride of 50
while (imgfilt_size < max_filt_size)
    for i=1:stride:(size(image,1)-imgfilt_size+1)
        for j=1:stride:(size(image,2)-imgfilt_size+1)
            subimg = image(i:(i+imgfilt_size-1),j:(j+imgfilt_size-1));
%             imshow(uint8(255*subimg));
            scaled_subimg = imresize(subimg, [24 24]);
            
            % Pass through Strong Classifiers
            isface = applyClassification(index,subimg,StrClass);
            if (isface)
                subimgs_passed{end+1} = [j i imgfilt_size imgfilt_size];
            end
            
        end
    end
    imgfilt_size = ceil(imgfilt_size*1.25);
end

%% Draw Rectangles

%Draw rectangles for sub-windows classified as faces.

% End result located in subimgs_passed which contains location of face
% start and size of the face box.
imshow(orig_image);
hold on
for face_dims=1:size(subimgs_passed,2)
    dims = subimgs_passed{face_dims};
    rectangle('position',dims,'edgecolor','r','LineWidth',1)
end;

%% Training Algorithm for building cascade detector

%Declare 
% f = maximum acceptable false positive rate per layer
% d = minimum acceptable detection rate per layer
% Ftarget = Overall false positive rate

%P = set of positive examples
%N = seto of negative examples
%F0 =1;
%D0 =1;


%Initialize i=0

%while Fi greater than Ftarget, current false positive rate is greater than
%desired positive rate
 
    %i = i +1; %This adds one more stage to the cascade
    %n(i) = 0; %Initialize the number of weak classifier for new stage to zero
    %F(i) = F(i-1); %Set new overall false positive rate to previous one

        %While F(i) > f * F(i-1) While the overall false positive rate is
        %greater than the maximum desired after this stage. Continue to get it
        %smaller

            %n(i) = n(i)+1; %Add one more feature to current strong classifier
            %Use P and N to train the classifier with n(i) features to determine
            %False positive rate and detection rate after current stage

            %Decrease threshold for this strong classifier until the current
            %cascaded filter has a detection rate of at least d x (Di-1)

            %This affects F(i) so recalculate F(i)

    % Clear N
    %If Fi>Ftarget, evaluate the current cascaded detector on the set of
    %non-face images and put any false detections into the set N

%End



%% Code to generate ROC curve

%We need to plot detection rate versus false positive rate

%Idea: evaluate strong classifier until a desired detection rate is
%achieved, then figure out the positive rate.



