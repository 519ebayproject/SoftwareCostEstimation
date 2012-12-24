function [ output_args ] = CrossValidation( rawStruct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

assert(isstruct(rawStruct),'Input is not struct');

rawData = rawStruct.data;

%get the size of the dataset
[rowNum, colNum] = size(rawData);

%generate indices for 3-fold cross-validation
indices = crossvalind('kfold',rowNum,3);



% iterate for 3 times to do the validation
for i=1:3
    %test is the indices for test set
    test = (indices ==i); 
    
    % the rest are indices for training set
    train = ~test;
       
    
    %training
    %build training set
    trainData = zeros(1,colNum);
    for k=1:rowNum
        if(train(k)==1)
            %disp(train(k));
           trainData(length(trainData)+1,:)= rawData(k,:);
        end
    end
    trainStruct = rawStruct;
    trainStruct.data = trainData;
    FSRlt = MIFS(trainStruct,9,1);
    %disp(FSRlt);
    
    
    %testing
    for j=1:rowNum
        if(test(j)==1)
            % add testing code here
            %disp( rawData(j,:));
        end
    end
    
    disp('-------------');
    


end

