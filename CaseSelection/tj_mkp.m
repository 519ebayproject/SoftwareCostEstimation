function [ neighbors ] = tj_mkp( input,k,max_dis,target )
%   Functionality: 
%   To select the nearest neighbors in accordance to the target.
%   Parameters:
%   input: historical cases (2-dimensional array)
%   k: the number of neighbors to select
%   max_dis: the maximum distance
%   target: the case to be predicted (1-dimensional array)

neighbors = tj_parzen_window(input,max_dis,target);
[row col] = size(neighbors);
if row < k
    neighbors = tj_knn(input,k,target);
    return;
end
return;
end

