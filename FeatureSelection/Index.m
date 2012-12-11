function [ index ] = Index( vector, value )
%INDEX Find the index of the value in a vector, if 0 is returned it means
%the value does not exist in the vector
%   Detailed explanation goes here
    index = 0;
    for i = 1 : length(vector)
        if (vector(i) == value)
            index = i;
        end
    end
end

