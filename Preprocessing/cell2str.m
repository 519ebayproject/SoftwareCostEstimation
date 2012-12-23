function [ string ] = cell2str( cells )
%CELL2STR Summary of this function goes here
%   Detailed explanation goes here
    assert(iscell(cells),'input is not cells');
    string = zeros(length(cells));
    for i = 1:length(cells)
        string(i) = cell2mat(cells(i));
    end

end

