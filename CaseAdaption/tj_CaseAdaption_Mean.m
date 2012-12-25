function [ estimation ] = tj_CaseAdaption_Mean( neighbors )
%   Functionality: 
%   To estimate the effort by calculating the mean efforts of neighbors.
%   Parameters:
%   neighbors: selected historical cases.

[row,col] = size(neighbors);

if row <=0 || col <=0
    estimation=-1;
    return ;
end

estimation = mean(neighbors(:,col-1));
return;
end

