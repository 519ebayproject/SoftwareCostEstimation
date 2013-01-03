function [args] = ValidationFramework(filepath,minK,maxK,minH,maxH,incH)

% filepath: the filepath of input dataset
% minK: the minimal number of neighbors to be evaluated for KNN and MKP
% maxK: the maximal number of neighbors to be evaluated for KNN and MKP
% minH: the minimal window size to be evaluated for Parzen Window and MKP
% maxH: the maximal window size to be evaluated for Parzen Window and MKP
% incH: the increment for window size for each evaluation of Parzen Window and MKP


disp('preprocessing...\n');
data = readData(filepath);
data = excludeNaN(data);
data = encapsulateData(data);

cleaned = Preprocess(data);

[trainSets, testSets]=divideInto3Fold(cleaned);


% for different case selection method, a loop
% but feature selection is needed only once
featureSets=[];

disp('feauture selection...\n');

for i=1:length(trainSets);
   fsRlt = MIFS(trainSets(i),5,0.2);
   featureSets=[featureSets;fsRlt];
   
end

 testSets=adjustTestSetWithFS(featureSets,testSets);
 %testSets = featureSets;

 % just for one kind method first
 
 fprintf('for knn k from %d to %d:\n',minK,maxK);
  outputMean = [];
  outputWeighted=[];
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
        
        outputMean = [outputMean;[knnInc,mmreMean,mdmreMean,predMean]];
        outputWeighted = [outputWeighted;[knnInc,mmreWeighted,mdmreWeighted,predWeighted]];
        
 end
       % output the results from experiments of KNN
       csvwrite('knn result.csv',[outputMean,outputWeighted]);
       disp('write knn result to csv');
       %disp([outputMean,outputWeighted]);
 
 
 fprintf('for parzen window h from %d to %d increased by %d:\n',minH,maxH,incH);
  outputMean = [];
  outputWeighted=[];
 for wndInc = minH:incH:maxH
     resultsMean=[];
     resultsWeighted=[];
     
     % to count how many cases cannot be estimated using this parameter
     caseWithNoNeighbours=0;
    for testSetIdx=1:length(testSets)
        currentTestSetData = testSets(testSetIdx).data;
        currentHistorySetData = featureSets(testSetIdx).data;

        [testSetRow,testSetCol]=size(currentTestSetData);

        for testCaseIdx=1:testSetRow
            % do case selection
          % neighbours = tj_knn(currentHistorySetData,knnInc,currentTestSetData(testCaseIdx,:));
           neighbours = tj_parzen_window(currentHistorySetData,wndInc,currentTestSetData(testCaseIdx,:));
           
           if(isempty(neighbours))
               caseWithNoNeighbours=caseWithNoNeighbours+1;
           end

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
        %disp(caseWithNoNeighbours);
        if(caseWithNoNeighbours > 0.33*testSetRow)
            % if unestimatable cases are over the 1/3 of the total cases
            mmreMean = -1;
            mdmreMean = -1;
            predMean = -1;
            
            mmreWeighted = -1;
            mdmreWeighted = -1;
            predWeighted = -1;
        else
            %for the results, calculate related metrics
            mmreMean = MMRE(resultsMean(:,1),resultsMean(:,2));
            mdmreMean = MdMRE(resultsMean(:,1),resultsMean(:,2));
            predMean = PRED025(resultsMean(:,1),resultsMean(:,2));

            mmreWeighted = MMRE(resultsWeighted(:,1),resultsWeighted(:,2));
            mdmreWeighted = MdMRE(resultsWeighted(:,1),resultsWeighted(:,2));
            predWeighted = PRED025(resultsWeighted(:,1),resultsWeighted(:,2));
        end  
        
        outputMean = [outputMean;[wndInc,mmreMean,mdmreMean,predMean]];
        outputWeighted = [outputWeighted;[wndInc,mmreWeighted,mdmreWeighted,predWeighted]];      
 end
    % output the results from experiments of Parzen Window
       csvwrite('parzen window result.csv',[outputMean,outputWeighted]);
       disp('write parzen window result to csv');
      %disp([outputMean,outputWeighted]);
 
 
  disp('for mkp:\n');
  outputMean = [];
  outputWeighted=[];
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
        
        outputMean=[outputMean;[wndInc,knnInc,mmreMean,mdmreMean,predMean]];
        outputWeighted=[outputWeighted;[wndInc,knnInc,mmreWeighted,mdmreWeighted,predWeighted]];
 end
        
 end
 %output the results from experiments of mpk
        csvwrite('mkp result.csv',[outputMean,outputWeighted]);
        disp('write mkp result to csv');
        %disp([outputMean,outputWeighted]);
end