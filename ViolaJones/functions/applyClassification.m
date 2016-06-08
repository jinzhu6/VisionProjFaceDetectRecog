function [faceornot] = applyClassification(index, image, strongClassifiers)
% Index, Input Image and cell array of strongClassifiers
% Each strong classifier struct will contain:
% - array of weights for each weak classifier
% - array of filter number for each weak classifier
% - array of polarity for each weak classifier
% - array of threshold for each weak classifier

for i = 1:size(strongClassifiers,2)
    if ~(applyStrongClassifier(index, image, strongClassifiers(i).alpha,strongClassifiers(i).weakClass, strongClassifiers(i).polarity,strongClassifiers(i).theta, strongClassifiers(i).Coefficient))
        % Did not pass this strong classifier
        faceornot = 0;
        break;
    else    
        faceornot= 1;
    end
    % Otherwise, passed this classifier so move on to next Strong
    % Classifier
end

% If passed all the filters

end