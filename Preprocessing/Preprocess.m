function [ Matrix ] = Preprocess( RawCells )
%PREPROCESS preprocess the data 
%   RawCells: with 3 fields, including title, type and data, which are all
%   strings

%   Remove the rows with NULL cells
%...
    
    Matrix.title = RawCells.title;
    Matrix.type = RawCells.type;
    Matrix.data = zeros(length(RawCells.data(:,1)),length(RawCells.data(1,:)));
    for i = 1:length(RawCells.title)
        Matrix.data(:,i) = Col_processing(RawCells.data(:,i));
    end

end

