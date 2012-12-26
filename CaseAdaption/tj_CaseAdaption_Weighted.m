function [ estimation ] = tj_CaseAdaption_Weighted( neighbors )
%   Functionality: 
%   To estimate the effort by calculating the weighted mean efforts of neighbors.
%   Parameters:
%   neighbors: selected historical cases.

[row,col] = size(neighbors);

if row <=0 || col <=0
    estimation=-1;
    return ;
end

sum_value=0;
sum_col=sum(neighbors(:,col));
for i=1:row
    sum_value=sum_value+neighbors(i,col-1)*(neighbors(i,col));
end
estimation = sum_value / sum_col;

return;

end

