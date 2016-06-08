function blobs = detectBlobsScaleFilter(im, n, blobsize, threshval, supsize, filterscale)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSSCALEFILTER(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the filter and keeps the
%   image same which is slow for big filters.
%
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is taken from:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector

% im = double(rgb2gray(im))/255;
im = double(im);

[h w] = size(im);

k = filterscale;
sigma = 0:(n-1);
init_sigma = blobsize;
sigma = init_sigma*k.^sigma;
filt_size = 1+2*ceil(sigma);
radius = sqrt(2)*sigma;

scaleSpace = zeros(h,w,n);
maxLocs = zeros(h,w,n);
for i=1:n
    fsize = filt_size(i);
    LoG =  sigma(i)^2 * fspecial('log', fsize+2*i, sigma(i));
    
    scaleSpace(:,:,i) = abs(imfilter(im, LoG, 'same', 'replicate'));
    
    maxLocs = imregionalmax(scaleSpace(:,:,i));
    scaleSpace(:,:,i) = scaleSpace(:,:,i).* maxLocs;
end


[maxAll maxLevLocs] = max(scaleSpace, [], 3);

% fun = @(x) max(x(:));
% maxLocs = nlfilter(maxAll,[supsize supsize],fun);
% maxLocs = colfilt(maxAll, [supsize supsize], 'sliding', @max);

maxLocs = ordfilt2(maxAll, supsize^2, ones(supsize,supsize));
maxLocs = maxLocs == maxAll;
maxAll = maxAll.*maxLocs;
maxLevLocs = maxLevLocs.*maxLocs;

threshmask = maxAll > threshval;
maxAll = maxAll.*threshmask;
maxLevLocs = maxLevLocs.*threshmask;

ind = find(maxAll ~= 0);
score = maxAll(ind);
levs = maxLevLocs(ind);
[a b] = ind2sub([h w], ind);

if (n == 1)
    s = radius(levs);
else
    s = radius(levs)';
end
blobs = [b a s score];