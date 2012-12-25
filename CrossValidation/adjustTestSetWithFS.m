function [ oTestSets ] = adjustTestSetWithFS( featureSets, iTestSets )
%ADJUSTTESTSETWITHFS 
% adjust the columns of test sets according the selected features
%inputs:
% featureSets: the struct contains the selected feautures
% iTestSets: the unadjusted test sets

%output:
% oTestSets: the adjusted test set

%   Detailed explanation goes here

oTestSets=[];

for idx=1:length(featureSets)
     % select certain columns for testing
    rawTestStruct=iTestSets(idx);
    fsRltTitle = featureSets(idx).title;
    fsRltColNum = length(fsRltTitle);
    rawTestDataTitle = iTestSets(idx).title;
    rawTestDataColNum = length(rawTestDataTitle);   
    
    testStruct=[];
    
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
    oTestSets=[oTestSets; testStruct];
end


end

