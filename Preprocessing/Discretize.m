function [ columnD ] = Discretize( column, n )
%DISCRETIZE equal length interval discretization
%   column: continuous data column
%   n: the number of intervals to be partition
%   the delimitor of each inverval is min+(max-min)/n

    % get the lower boudary and the upper boudary
    Max = max(column);Min = min(column);
    % get the interval
    interval = (Max-Min)/n;
    % initialize output value
    columnD = zeros(length(column),1);
    % discretize the values
    for i = 1 : length(column)
        % judge j-th group the i-th value belongs to
        for j = 1:n
            if column(i) <= (Min + interval * j)
                columnD(i) = j;
                break;
            end
        end
    end

end

