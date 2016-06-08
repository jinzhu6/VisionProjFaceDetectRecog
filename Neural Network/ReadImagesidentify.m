%Script to read images for test data

clear
close all 
clc

% Read Att Faces
dataDir     = fullfile('Databases\'); % Path to your data directory
numSubjects = 40;
numImTrain = 5;


%Create Traning dataset

train_data = [];
train_label =[];
%Code to Read att_faces images
for i=1:numSubjects
    train_label = vertcat(train_label, i*ones(1,numImTrain)');
    for j= 1:5 %PIck the first 5 images for each subject
        imageDir    = fullfile(dataDir, ['s' num2str(i)]);
        num = num2str(j);
        path =[imageDir,'\', num, '.pgm'];
        imArray = double(imread(path))/255;
        train_data = cat(4,train_data, imArray);

    end
end

%Create Test dataset

test_data = [];
test_label =[];
%Code to Read att_faces images
for i=1:numSubjects
    test_label = vertcat(test_label, i*ones(1,10)');
    for j= 1:10 %Pick all 10 images for each subject
        imageDir    = fullfile(dataDir, ['s' num2str(i)]);
        num = num2str(j);
        path =[imageDir,'\', num, '.pgm'];
        imArray = double(imread(path))/255;
        test_data = cat(4,test_data, imArray);

    end
end




% for i=1:15
% 
% X = imread([int2str(i),'.jpg']);
% imwrite(X,[int2str(i),'.bmp'])
% 
% end
% 
% X = imread('car.png');
% imwrite(X,'car.bmp')