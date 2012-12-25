function [args] = ValidationFramework(filepath,minK,maxK,minH,maxH,incH)
data = readData(filepath);
data = excludeNaN(data);
data = encapsulateData(data);

cleaned = Preprocess(data);

[trainSets, testSets]=divideInto3Fold(cleaned);


% for different case selection method, a loop
% but feature selection is needed only once
featureSets=[];

for i=1:length(trainSets);
   fsRlt = MIFS(trainSets(i),5,1);
   featureSets=[featureSets;fsRlt];
end

 testSets=adjustTestSetWithFS(featureSets,testSets);

 % just for one kind method first
 
 fprintf('for knn k from %d to %d:\n',minK,maxK);
  output = [];
 for knnInc = minK:maxK
 % validation begins
 resultsMean=[];
 resultsWeighted=[];
    for testSetIdx=1:length(testSets)
        currentTestSetData = testSets(testSetIdx).data;
        currentHistorySetData = featureSets(testSetIdx).data;

        [testSetRow,testSetCol]=size(currentTestSetData);

        for testCaseIdx=1:testSetRow
            % do case selection
           neighbours = tj_knn(currentHistorySetData,knnInc,currentTestSetData(testCaseIdx,:));
           
            % do case adaption
            estMean = tj_CaseAdaption_Mean(neighbours);
            estWeighted = tj_CaseAdaption_Weighted(neighbours);

            %find the acutal effort from the input test set
            act = currentHistorySetData(testCaseIdx,testSetCol);

            resultsMean=[resultsMean;[act,estMean]];
            resultsWeighted = [resultsWeighted;[act,estWeighted]];
        end    
    end
           % disp(results);

        %for the results, calculate related metrics
        mmreMean = MMRE(resultsMean(:,1),resultsMean(:,2));
        mdmreMean = MdMRE(resultsMean(:,1),resultsMean(:,2));
        predMean = PRED025(resultsMean(:,1),resultsMean(:,2));
        
        mmreWeighted = MMRE(resultsWeighted(:,1),resultsWeighted(:,2));
        mdmreWeighted = MdMRE(resultsWeighted(:,1),resultsWeighted(:,2));
        predWeighted = PRED025(resultsWeighted(:,1),resultsWeighted(:,2));
        
        output = [output;[knnInc,mmreMean,mdmreMean,predMean]];
        output = [output;[knnInc,mmreWeighted,mdmreWeighted,predWeighted]];
        
 end
       % output the results from experiments of KNN
       csvwrite('knn result.csv',output);
 
 
 fprintf('for parzen window h from %d to %d increased by %d:\n',minH,maxH,incH);
 output = [];
 for wndInc = minH:incH:maxH
     resultsMean=[];
     resultsWeighted=[];
    for testSetIdx=1:length(testSets)
        currentTestSetData = testSets(testSetIdx).data;
        currentHistorySetData = featureSets(testSetIdx).data;

        [testSetRow,testSetCol]=size(currentTestSetData);

        for testCaseIdx=1:testSetRow
            % do case selection
          % neighbours = tj_knn(currentHistorySetData,knnInc,currentTestSetData(testCaseIdx,:));
           neighbours = tj_parzen_window(currentHistorySetData,wndInc,currentTestSetData(testCaseIdx,:));

            % do case adaption
            estMean = tj_CaseAdaption_Mean(neighbours);
            estWeighted = tj_CaseAdaption_Weighted(neighbours);

            %find the acutal effort from the input test set
            act = currentHistorySetData(testCaseIdx,testSetCol);

            resultsMean=[resultsMean;[act,estMean]];
            resultsWeighted = [resultsWeighted;[act,estWeighted]];
        end    
    end
           % disp(results);

        %for the results, calculate related metrics
        mmreMean = MMRE(resultsMean(:,1),resultsMean(:,2));
        mdmreMean = MdMRE(resultsMean(:,1),resultsMean(:,2));
        predMean = PRED025(resultsMean(:,1),resultsMean(:,2));
        
        mmreWeighted = MMRE(resultsWeighted(:,1),resultsWeighted(:,2));
        mdmreWeighted = MdMRE(resultsWeighted(:,1),resultsWeighted(:,2));
        predWeighted = PRED025(resultsWeighted(:,1),resultsWeighted(:,2));
        
        output = [output;[wndInc,mmreMean,mdmreMean,predMean]];
        output = [output;[wndInc,mmreWeighted,mdmreWeighted,predWeighted]];      
 end
    % output the results from experiments of Parzen Window
       csvwrite('parzen window result.csv',output);
 
 
  disp('for mkp:\n');
  output =[];
 for wndInc = minH:incH:maxH
 for knnInc= minK:maxK
     resultsMean=[];
    for testSetIdx=1:length(testSets)
        currentTestSetData = testSets(testSetIdx).data;
        currentHistorySetData = featureSets(testSetIdx).data;

        [testSetRow,testSetCol]=size(currentTestSetData);

        for testCaseIdx=1:testSetRow
            % do case selection
          % neighbours = tj_knn(currentHistorySetData,knnInc,currentTestSetData(testCaseIdx,:));
           neighbours = tj_mkp(currentHistorySetData,knnInc,wndInc,currentTestSetData(testCaseIdx,:));

             % do case adaption
            estMean = tj_CaseAdaption_Mean(neighbours);
            estWeighted = tj_CaseAdaption_Weighted(neighbours);

            %find the acutal effort from the input test set
            act = currentHistorySetData(testCaseIdx,testSetCol);

            resultsMean=[resultsMean;[act,estMean]];
            resultsWeighted = [resultsWeighted;[act,estMean]];
        end    
    end
           % disp(results);

        %for the results, calculate related metrics
        mmreMean = MMRE(resultsMean(:,1),resultsMean(:,2));
        mdmreMean = MdMRE(resultsMean(:,1),resultsMean(:,2));
        predMean = PRED025(resultsMean(:,1),resultsMean(:,2));
        
        mmreWeighted = MMRE(resultsWeighted(:,1),resultsWeighted(:,2));
        mdmreWeighted = MdMRE(resultsWeighted(:,1),resultsWeighted(:,2));
        predWeighted = PRED025(resultsWeighted(:,1),resultsWeighted(:,2));
        
        output=[output;[wndInc,knnInc,mmreMean,mdmreMean,predMean]];
        output=[output;[wndInc,knnInc,mmreWeighted,mdmreWeighted,predWeighted]];
 end
        %output the results from experiments of mpk
        csvwrite('mkp result.csv',output);
 end
 
end