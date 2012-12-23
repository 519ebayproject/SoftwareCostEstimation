function [ output_args ] = CrossValidation( DataSet )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%get the size of the dataset
[rowNum, colNum] = size(DataSet)

%generate indices for 3-fold cross-validation
indices = crossvalind('kfold',rowNum,3);

% iterate for 3 times to do the validation
for i=1:3
    %test is the indices for test set
    test = (indices ==i); 
    
    % the rest are indices for training set
    train = ~test;
    
    %training
    for k=1:rowNum
        if(train(k)==1)
            %disp(train(k));
            %add training code here
           disp( DataSet(k,:));
        end
    end
    
    %testing
    for j=1:rowNum
        if(test(j)==1)
            % add testing code here
            disp( DataSet(j,:));
        end
    end
    
    disp('-------------');
    


end

