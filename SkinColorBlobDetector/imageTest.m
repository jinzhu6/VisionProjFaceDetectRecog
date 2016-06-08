close all; clear; clc;

% Uncomment one of the following depending on the image you would like to
% use. The code may take 1 or 2 minutes to run so please be patient =).
picName = 'IMG_0587.JPG';
% picName = 'IMG_0588.JPG';
% picName = 'IMG_0589.JPG';
% picName = 'IMG_0590.JPG';
% picName = 'IMG_0591.JPG';
% picName = 'IMG_0592.JPG';
% picName = 'IMG_0593.JPG';
% picName = 'IMG_0594.JPG';
% picName = 'IMG_0595.JPG';
% picName = 'IMG_0596.JPG';
% picName = 'IMG_0597.JPG';
% picName = 'IMG_0598.JPG';
% picName = 'IMG_0599.JPG';
% picName = 'IMG_0600.JPG';


img = imread(['ClassPictures/' picName]);
imageSegment(img);