function [ mmre, mdmre, pred ] = CrossValidation( rawStruct, evalMethod)
%UNTITLED Summary of this function goes here
%   rawStruct is the structure holds the cleanded data
    % with .title
    %      .type
    %      .data
    
    % evalMethod
    % the process of certain method to calculate the estimates
    
%   Detailed explanation goes here

assert(isstruct(rawStruct),'Input is not struct');

rawData = rawStruct.data;

%get the size of the dataset
[rowNum, colNum] = size(rawData);

%generate indices for 3-fold cross-validation
indices = crossvalind('kfold',rowNum,3);

 % define the martix holds the actual effort & estimate effort
 results=zeros(1,2);

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
    FSRlt = MIFS(trainStruct,9,1);
    disp(FSRlt);
    
    
    %testing
    %build testng set
    %step 1: select the rows which are not used for feature selection
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
    
    %step 2: select data with correspondent columns selected with mutual
    %information
    
    rawTestStruct = rawStruct;
    rawTestStruct.data = rawTestData;
    
    %define the struct to hold the final test data
    testStruct = FSRlt;
    testStruct.data =[];
    
    % select certain rows for testing
    fsRltTitle = FSRlt.title;
    fsRltColNum = length(fsRltTitle);
    rawTestDataTitle = rawTestStruct.title;
    rawTestDataColNum = length(rawTestDataTitle);
    
    % loop with low efficiency = =, how to select columns with certain
    % features? any good solution?
    for idxFSRlt = 1:fsRltColNum
        for idxRawTestData = 1: rawTestDataColNum
            if(strcmp(fsRltTitle(idxFSRlt),rawTestDataTitle(idxRawTestData)))
                testStruct.title(idxFSRlt) = rawTestStruct.title(idxRawTestData);
                testStruct.type(idxFSRlt) = rawTestStruct.type(idxRawTestData);
                testStruct.data(:,idxFSRlt) = rawTestStruct.data(:,idxRawTestData);
            end
        end
    end
    
    %get correct TestStruct here
    
    disp(testStruct);
    
    
   % a = tj_knn(FSRlt.data,3,testStruct.data(1,:));
   estimates = evalMethod(FSRlt,testStruct);
   actuals = rawTestStruct.data(:,rawTestDataColNum);
   
   % combine estimates and actuals together
   results = [results;[actuals,estimates]];
   
    
    
    disp(a);
    
    disp('-------------');
end

% after the experiments have been conducted three times.
% to get metrics
mmre = MMRE(results(:,1),results(:,2));
mdmre = MdMRE(results(:,1),results(:,2));
pred = PRED025(results(:,1),results(:,2));








