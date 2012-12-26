function [ neighbors ] = tj_parzen_window( input,max_dis,target )
%   Functionality: 
%   To select the nearest neighbors in accordance to the target.
%   Parameters:
%   input: historical cases (2-dimensional array)
%   max_dis: the maximum distance
%   target: the case to be predicted (1-dimensional array)
adjust_value=0.001;
[input_row_num,input_col_num] = size(input);
target_col_num = length(target);
neighbors = [];
if input_col_num ~= target_col_num || max_dis<=0
    return;
end
% neighbors = zeros(k,input_col_num);
dis = zeros(input_row_num,2);
for row=1:input_row_num
    distance = 0;
    for col=1:input_col_num-1
        distance = distance + (target(col)-input(row,col))^2;
    end
    dis(row,1) = sqrt(distance); dis(row,2) = row;
end
j=1;
while j~=input_row_num+1
    if dis(j,1) <= max_dis
        neighbors(j,(1:input_col_num))=input(dis(j,2),:);
        neighbors(j,input_col_num+1)=1/(dis(j,1)+adjust_value);
    end
    j=j+1;
end
end

