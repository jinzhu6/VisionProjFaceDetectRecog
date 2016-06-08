function [ maxAllaft ] = harrisdetect(im, maxAll, ratiolim, filtsize)
% HARRISDETECT() detects where there is an edge in the image and filters out
% any blobs triggered by the edge
%   IM is given as the original image
%   MAXALL contains the values where the blobs are triggered after non-maximum
%   suppression.
%   FILTSIZE is the area at which to check if an edge occured
%   RATIOLIM is the ratio of dy/dx or dx/dy at which the blob would be filtered 
%   out.

dx = [-1 zeros(1,filtsize-2) 1; -1 zeros(1,filtsize-2) 1; -1 zeros(1,filtsize-2) 1];
dy = dx';
imx = conv2(im, dx, 'same');
imy = conv2(im, dy, 'same');
ratioy = abs(imy./imx);
ratiox = abs(imx./imy);

maxAllaft = maxAll.*~(ratioy > ratiolim);
maxAllaft = maxAll.*~(ratiox > ratiolim);
end