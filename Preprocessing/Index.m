function [ index ] = Index( vector, value )
%INDEX Find the index of the value in a vector, if 0 is returned it means
%the value does not exist in the vector
%   Detailed explanation goes here
    index = 0;
    if iscell(value) 
      tmpval = cell2mat(value);
      for i = 1 : length(vector)
        tmpvec = cell2mat(vector(i));
        if length(tmpvec)~=length(tmpval)
            continue;
        end
        if(tmpvec == tmpval)
            index = i;
        end
      end
    else
      for i = 1 : length(vector)
        if (vector(i) == value)
            index = i;
        end
      end
    end
end

