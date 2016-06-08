function [faceornot] = applyStrongClassifier(index, image, weight, filter_number, polarity, threshold, coefficient)

summ = 0;
finalthresh = coefficient*sum(weight)/2;


for i=1:length(filter_number)
    ind = filter_number(i);
    filter =  filterOnly(getfield(index,'filter_type',{ind,1}),index(ind).filter_size,getfield(index,'start_index',{ind,1}));
    resizedImg = imresize(image,[24 24]);
    
    if (polarity(i)==1)
        summ = summ + weight(i)*(sum(sum(resizedImg.*filter)) > threshold(i));
    else
        summ = summ + weight(i)*(sum(sum(resizedImg.*filter)) < threshold(i));
    end
end

if (summ > finalthresh)
    faceornot = 1;
else
    faceornot = 0;
end

end