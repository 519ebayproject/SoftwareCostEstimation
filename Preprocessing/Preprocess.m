function [ Matrix ] = Preprocess( RawCells )
%PREPROCESS preprocess the data 
%   RawCells: with 3 fields, including title, type and data, which are all
%   strings
    assert(isstruct(RawCells),'Input is not struct');
    
    Matrix.title = RawCells.title;
    Matrix.type = RawCells.type;
    Matrix.data = zeros(length(RawCells.data(:,1)),length(RawCells.data(1,:)));
    % no operation on the last column(Effort)
    for i = 1:(length(RawCells.title)-1)
        Col.title=Matrix.title(i);
        Col.type=Matrix.type(i);
        Col.data=RawCells.data(:,i);
        Matrix.data(:,i) = Col_processing(Col);
    end
    Matrix.data(:,length(RawCells.title)) = cell2mat(RawCells.data(:,length(RawCells.title)));

end

