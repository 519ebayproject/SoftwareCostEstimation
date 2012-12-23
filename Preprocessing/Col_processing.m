function [ Cleaned ] = Col_processing( Raw )
%COL_PROCESSING mapping the data to interval [0,1]
%   Raw: a vector hold the data in one colunm sequently
%       it has three fields: title,type and data, among which are cells
%   using the formula: x'=(x-min)/(max-min)
    assert(isstruct(Raw),'Input data is not a struct');
%   Standarlize the data
    Cleaned = zeros(length(Raw.data),1);
    ExistedValue = cell(0);
    if Raw.type{1} == 'D'
        for i = 1 : length(Raw.data)
            index = Index(ExistedValue,Raw.data(i));
            if  index == 0
                %tmpval = cell2mat(Raw.data(i));
                ExistedValue(length(ExistedValue)+1) = Raw.data(i);
            end
            Cleaned(i) = index;  
        end
    else if Raw.type{1} == 'C'
        mat = cell2mat(Raw.data);
        Cleaned = (mat - min(mat)) * (max(mat) - min(mat))^(-1);
        % imagine we have 5 intevals to discretize the continuous data.
        %Cleaned = Discretize(Cleaned,30)
        end
    end
end