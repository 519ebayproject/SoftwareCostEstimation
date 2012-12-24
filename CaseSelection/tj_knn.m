function [ k_neighbors ] = tj_knn( input,k,target )
%   Functionality: 
%   To select the k nearest neighbors in accordance to the target.
%   Parameters:
%   input: historical cases (2-dimensional array)
%   k: the number of neighbors to select
%   target: the case to be predicted (1-dimensional array)

[input_row_num,input_col_num] = size(input);
target_col_num = length(target);
if input_col_num ~= target_col_num || k<0
    k_neighbors = [];
    return;
end
if input_row_num<k
    k_neighbors = input;
    return;
end
k_neighbors = zeros(k,input_col_num);
dis = zeros(input_row_num,2);
for row=1:input_row_num
    distance = 0;
    for col=1:input_col_num-1
        distance = distance + (target(col)-input(row,col))^2;
    end
    dis(row,1) = sqrt(distance); dis(row,2) = row;
end
j=0;
while j~=k
    x=find(dis(:,1)==min(dis(:,1)));
    for l=1:length(x)
        k_neighbors(j+1)=input(dis(x(l),2));
        j=j+1;
        if j == k
            break;
        end
    end
    dis(x,:)=[];
end
end

