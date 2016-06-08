%Mahalanobis Distance

function dist = Mahalanobis_dis(A,B,evals)

[ra, ca] = size(A); 
% ra is the number of vectors
% ca is the nuumber of entries in each vector
[rb, cb] = size(B);


% for i=1:ra
%     for j=1:rb
%         dist(i,j) = - (A(i,:)./sqrt(evals))*B(j,:)';
%     end
% end


for i=1:ra
    for j=1:rb
        dist(i,j) = sum((1./evals).*(A(i,:) -B(j,:)).^2);
    end
end

        