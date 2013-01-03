function [ trainSets, testSets ] = divideInto3Fold( rawStruct )
%DIVIDEINTO3FOLD Summary of this function goes here
%   rawStruct is the structure holds the cleanded data
    % with .title
    %      .type
    %      .data
%   Detailed explanation goes here

assert(isstruct(rawStruct),'Input is not struct');

% define output variables
trainSets=[];
testSets=[];

rawData = rawStruct.data;


%get the size of the dataset
[rowNum, colNum] = size(rawData);

%generate indices for 3-fold cross-validation
indices = crossvalind('kfold',rowNum,3);

 % define the martix holds the actual effort & estimate effort

% iterate for 3 times to do the validation
for i=1:3
    %test is the indices for test set
    test = (indices ==i); 
    
    % the rest are indices for training set
    train = ~test;
       
    
    %training
    %build training set
    % something strange happens here
    trainData = zeros(colNum,colNum);
    for k=1:rowNum
        if(train(k)==1)
            %disp(train(k));
           trainData(length(trainData)+1,:)= rawData(k,:);
        end
    end
    %delete the rows with 0
    trainData(1:colNum,:)=[];
    
    trainStruct = rawStruct;
    trainStruct.data = trainData;
    
    trainSets= [trainSets;trainStruct];

    
    
    %testing
    %build testng set
 
    rawTestData = zeros(colNum, colNum);
    for j=1:rowNum
        if(test(j)==1)
            % add testing code here
            %disp( rawData(j,:));
            rawTestData(length(rawTestData)+1,:)=rawData(j,:);
        end
    end
    %delete the rows with 0
    rawTestData(1:colNum,:)=[];
    rawTestStruct = rawStruct;
    rawTestStruct.data = rawTestData;
    
    testSets=[testSets;rawTestStruct];
   
    
   % disp(rawTestStruct);
    
 
end

end

