function [trainImages, trainLabels, testImages, testLabels] = ReadImagesfaceornot(numFaceImages,numBgImages,numFaceTestImages,numBgTestImages)
%% Create Training Dataset
% Read face images
dataDir= fullfile('faces\'); % Path to your data directory

%Create Face dataset
FaceImages = [];

%Read Images
for i=1:numFaceImages
        imageDir = fullfile(dataDir, ['face' num2str(i)]);
        path =[imageDir,'.jpg'];
        imArray = double(rgb2gray(imread(path)))/255;
        imArray = imresize(imArray, [24,24]);
        
        %Normalize Image with mean and variance
        imArray = (imArray - mean(imArray(:)))./std(imArray(:));
        FaceImages = cat(4,FaceImages, imArray);
end


% Read face images
dataDir = fullfile('background\'); % Path to your data directory

%Create background dataset
BgImages = [];

%Code to Read att_faces images
for i=1:numBgImages
        path =[dataDir,num2str(i),'.jpg'];
        imArray = double(rgb2gray(imread(path)))/255;
        imArray = imresize(imArray, [24,24]);
        
        %Normalize Image with mean and variance
        imArray = (imArray - mean(imArray(:)))./std(imArray(:));
        BgImages = cat(4,BgImages, imArray);
end


% Concatenate images into one array
trainImages = cat(4, FaceImages, BgImages);

% Create Labels
trainLabels = [ones(numFaceImages,1); 2*ones(numBgImages,1)];


%% Create Testing Dataset
% Read face images
dataDir= fullfile('faces\'); % Path to your data directory

%Create Face dataset
FaceTestImages = [];

%Read Images
for i=numFaceImages+1:numFaceImages+numFaceTestImages
        imageDir = fullfile(dataDir, ['face' num2str(i)]);
        path =[imageDir,'.jpg'];
        imArray = double(rgb2gray(imread(path)))/255;
        imArray = imresize(imArray, [24,24]);
        
        %Normalize Image with mean and variance
        imArray = (imArray - mean(imArray(:)))./std(imArray(:));
        FaceTestImages = cat(4,FaceTestImages, imArray);
end


% Read face images
dataDir = fullfile('background\'); % Path to your data directory

%Create background dataset
BgTestImages = [];

%Code to Read att_faces images
for i=numBgImages+1:numBgImages+numBgTestImages
        path =[dataDir,num2str(i),'.jpg'];
        imArray = double(rgb2gray(imread(path)))/255;
        imArray = imresize(imArray, [24,24]);
        
        %Normalize Image with mean and variance
        imArray = (imArray - mean(imArray(:)))./std(imArray(:));
        BgTestImages = cat(4,BgTestImages, imArray);
end


% Concatenate images into one array
testImages = cat(4, FaceTestImages, BgTestImages);

% Create Labels
testLabels = [ones(numFaceTestImages,1); 2*ones(numBgTestImages,1)];
end