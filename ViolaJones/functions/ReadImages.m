function [All_images, FaceImages, BgImages, Labels] = ReadImages(numFaceImages,numBgImages)


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
        FaceImages = cat(3,FaceImages, imArray);
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
        BgImages = cat(3,BgImages, imArray);
end


% Concatenate images into one array
All_images = cat(3, FaceImages, BgImages);

% Create Labels
Labels = [ones(1,numFaceImages), zeros(1, numBgImages)];


%Randomize
% P = randperm(numImages);
% 
% All_images = All_images(:,:,P);
% 
% Labels = Labels(P);
end
