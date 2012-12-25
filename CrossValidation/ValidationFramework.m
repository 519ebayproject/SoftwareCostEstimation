data = readData('ISBSG[USE].xls');
data = excludeNaN(data);
data = encapsulateData(data);

cleaned = Preprocess(data);

[trainSets, testSets]=divideInto3Fold(cleaned);


% for different case selection method, a loop
% but feature selection is needed only once
featureSets=[];

for i=1:length(trainSets);
   fsRlt = MIFS(trainSets(i),9,1);
   featureSets=[featureSets;fsRlt];
end

 testSets=adjustTestSetWithFS(featureSets,testSets);

 % just for one kind method first
 
 % validation begins
 results=[];
for testSetIdx=1:length(testSets)
    currentTestSetData = testSets(testSetIdx).data;
    currentTrainSetData = featureSets(testSetIdx).data;
    
    [testSetRol,testSetCol]=size(currentTestSetData);
    
    for testCaseIdx=1:testSetRol
        % do case selection
       % neighbours = tj_knn(currentTrainSetData,3,currentTestSetData(testCaseIdx,:));
       neighbours = tj_parzen_window(currentTrainSetData,4.0,currentTestSetData(testCaseIdx,:));

        % do case adaption
        est = tj_CaseAdaption_Mean(neighbours);
        
        %find the acutal effort from the input test set
        act = currentTrainSetData(testCaseIdx,testSetCol);
        
        results=[results;[act,est]];
    end    
    disp(results);
    
    %for the results, calculate related metrics
    mmre = MMRE(results(:,1),results(:,2));
    mdmre = MdMRE(results(:,1),results(:,2));
    pred = PRED025(results(:,1),results(:,2));
    
    disp(mmre);
    disp(mdmre);
    disp(pred);
    
end
