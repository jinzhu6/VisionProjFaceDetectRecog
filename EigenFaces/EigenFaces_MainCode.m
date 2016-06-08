%%EECS 442 - Project
%Implementation of Eigenfaces algorithm
%Written by Sahit Bollineni and Juan Orozco

%Tabula Rasa
clc
clear all;
close all;

%%% Read Faces in AT&T database
Att_images = [];
dataDir     = fullfile('Databases\att_faces'); % Path to your data directory
 subjectName = {'s1', 's2', 's3', 's4','s5','s6','s7', 's8', 's9' ,'s10','s11','s12', 's13' ,'s14','s15', 's16', 's17' ,'s18','s19', 's20' };
 numImages   = 5; 
 numSubjects = size(subjectName,2);
 
%Code to Read att_faces images
for i=1:numSubjects
    for j= 1:numImages % There is 10 pics in each folder
    imageDir    = fullfile(dataDir, subjectName{1,i});
    num = num2str(j);
    path =[imageDir,'\', num, '.pgm'];
    imArray = double(imread(path));
    imArray = (imArray - mean(imArray(:)))./std(imArray(:));
    Att_images = cat(3,Att_images, imArray);
    end
end

All_images = Att_images;


%Determine height, width, and number of pictures
[h,w,n] = size(All_images);
d = h*w;

% vectorize images
x = reshape(All_images,[d n]);
x = double(x);


%Mean Image
meanIm = mean(x,2);

%Subtract mean image from all images
x = x - repmat(meanIm,[1 n]);

% Calculate matrix L from paper
L = x'*x;

[V,D] = eig(L);
eigval = diag(D);

eigval = eigval(end:-1:1);
V = fliplr(V);

% Eigenvectors of C matrix
U=[];
for i=1:size(V,2)
temp=sqrt(eigval(i));
U=[U (x*V(:,i))./temp]; % eigenvectors are normalized to a length of 1
end


%Number of Eigenfaces
%A heuristic is to use 60% of all the eigenvalues
numPC = floor(size(U,2)*0.3);
% numPC = 5; %200


%Calculate weights for all images
%Basically, we calculate the coordinates of each image using the basis of
%the principal components 
Weights_PC = U(:,1:numPC)'*x;


%Determine mean weights for all subjects for classification
%This is what is wrong
%I should find the coordinates for all the subject images in the PCA bases
%Find weights. 

for i=1:numSubjects
    sWeights(:,i) = mean(U(:,1:numPC)'*x(:,1 + numImages*(i-1):numImages*(i-1) + numImages),2);
%     sWeights(:,i) = mean(Weights_PC(:,1 + numImages*(i-1):numImages*(i-1)+numImages),2);
end


%Read Test Image and normalize
InputImage = double(imread('Databases\att_faces\s7\7.pgm'));
InputImage = (InputImage - mean(InputImage(:)))./std(InputImage(:));
InputImage = imresize(InputImage, [h w]);


TestImage = InputImage;

%Plot test image
figure(1)
subplot(1,2,1)
imagesc(TestImage)
title('Test Image')
axis off

TestImage = reshape(TestImage, [d 1]);
TestImage = TestImage - meanIm;

Weights_TI = U(:, 1:numPC)'*TestImage;
reconIm = U(:,1:numPC)*Weights_TI + meanIm;

reconIm = reshape(reconIm, [h w]);
subplot(1,2,2)
imagesc(reconIm); colormap('gray');
title('Reconstructed Image')
axis off


%Calculate distance

%Eucledian distance
% dist_PC = sqrt(dist2(Weights_PC', Weights_TI'));
% dist_Sub = sqrt(dist2(sWeights', Weights_TI'));


%Mahalanobis distance (custom created function)
dist_PC = Mahalanobis_dis(Weights_PC', Weights_TI', eigval(1:numPC)');
dist_Sub = Mahalanobis_dis(sWeights', Weights_TI', eigval(1:numPC)');

%Mahalanobis distance (MATLAB Function)
% dist_PC = mahal(Weights_TI', Weights_PC');
% dist_Sub = mahal(sWeights', Weights_TI');

[min_distPC, mindistPC_im] = min(dist_PC)
[min_distSub, mindistSub_Sub] = min(dist_Sub)


%Plot weights of test image, distance to all training images, and distance
%to different subjects.
% figure(2)
% subplot(1,3,1)
% stem(Weights_TI)
% title('Weights of Eigenfaces')
% subplot(1,3,2)
% stem(dist_PC)
% title('Distance to All Training Images')
% subplot(1,3,3)
% stem(dist_Sub)
% title('Distance to Different Subjects')

%Plot distance of test image to characterized subjects
figure(3)
stem(dist_Sub)
xlabel('Subject')
title('Distance to Characterized Subjects')



%% %Now we determine if a specific image is in the dataset

%Build array of all images
Test_images = [];

Att_images_new = [];
dataDir     = fullfile('Databases\att_faces'); % Path to your data directory
 subjectName = {'s1', 's2', 's3', 's4','s5','s6','s7', 's8', 's9' ,'s10','s11','s12', 's13' ,'s14','s15', 's16', 's17' ,'s18','s19', 's20' };
%  numImages   = 5; 
 numSubjects = size(subjectName,2);
 
%Code to Read att_faces images
for i=1:numSubjects
    for j= 1 :5 % There is 10 pics in each folder
    imageDir    = fullfile(dataDir, subjectName{1,i});
    num = num2str(j);
    path =[imageDir,'\', num, '.pgm'];
    imArray = double(imread(path));
    imArray = (imArray - mean(imArray(:)))./std(imArray(:));
    Att_images_new = cat(3,Att_images_new, imArray);
    end
end


Test_images = Att_images_new;


total=0;
correct =0;
for i=1: size(Test_images,3)
    
    %Determine subject identity
    sub = floor(i/5)+1;
    

    %Test Image
    TestImage = reshape(Test_images(:,:,i), [d 1]);
    TestImage = TestImage - meanIm;
    
    % epsilon = TestImage - V(:,1:numPC)*Weights_PC;
    
    % %Weights for test image
    Weights_TI = U(:, 1:numPC)'*TestImage;
    
    
    %Determine distance between test image and Principal Components for all
    %images
    dist_PC = sqrt(dist2(Weights_PC', Weights_TI'));
    
    
    %Determine distance between test image and main subject classes
    dist_Sub = sqrt(dist2(sWeights', Weights_TI'));
    
    [min_dist,subject] = min(dist_Sub);
    
    if subject == sub % && min_dist <Threshold
        correct=correct+1;
    end
    
    total = total+1;
    
    
end

%Calculate percent of images that were correctly classified
percent_correct = correct*100/total

%% Plot 9 top eigenfaces
% show 0th through 15th principal eigenvectors
eig0 = reshape(meanIm, [h,w]);

figure %,subplot(4,4,1)
% imagesc(eig0)
colormap gray

for i = 1:9
    subplot(3,3,i)
    imagesc(reshape(U(:,i),h,w))
    axis off
end










