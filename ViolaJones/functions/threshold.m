function [theta, direction] = threshold(weights, labels, data)
%This function calculates the threshold to classify all the images for one
%specific type of feature


%1. Sort the examples based on the feature values
[sorted_data, indices] = sort(data);

%Sort labels 
sorted_labels = labels(indices);

%Sort weights 
sorted_weights = weights(indices);

%Number of samples or filters
samples = length(data);


%2. For each element, we evaluate four different sums
%   T+ = total sum of positive example weights
%   T- = Total sum of negative example weights
%   S+ = Sum of positive weights below current example
%   S- = Sum of negative weights below current example

%Initialize Variables
Tplus = sum(sorted_weights(sorted_labels==1));
Tminus = sum(sorted_weights(sorted_labels==0));
Splus= zeros(1,samples);
Sminus = Splus;


% for i=1:samples
% 
%        S_plus_new(i) = sum(sorted_weights(find(i>find(sorted_labels==+1))));
%        S_minus_new(i) = sum(sorted_weights(find(i>find(sorted_labels==0))));
%     
% end
    
    %     for j=1:i  
%         if sorted_labels(j) == 1
%             Splus(i)= Splus(i)+sorted_weights(i);
%         else
%             Sminus(i)= Sminus(i)+ sorted_weights(i);
%         end
%     end
% end


 Splus = cumsum(sorted_labels.*sorted_weights);
 Sminus = cumsum((sorted_labels==0).*sorted_weights);

%  Splus_last = cumsum(sorted_labels.*sorted_weights);
%  Sminus_last = cumsum((sorted_labels==0).*sorted_weights);
% 
%  Sminus = [ 0 Sminus_last(1:end-1)];
%  Splus = [ 0 Splus_last(1:end-1)];
%  
 
Temp1 = Splus + Tminus - Sminus;
Temp2 = Sminus + Tplus - Splus;

% error = min(Splus + Tminus - Sminus, Sminus + Tplus - Splus) 
error = min(Temp1, Temp2);

[min_error, min_error_index] =min(error);

if Temp1(min_error_index) == min_error
    direction = 1; %Above threshold we have faces
else
    direction = 0; %Above threshold we have nonfaces
end

%threshold is equal to the average between the values that gave the minimum
%error
% theta = 0.5*(sorted_data(min_error_index) - sorted_data(min_error_index+1));
theta = sorted_data(min_error_index);

