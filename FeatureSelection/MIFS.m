function [ S ] = MIFS( table, m, beta )
%Using mutual inforamation feature selection method
% the package InfoTheory by Mo Chen is used to compute mutual information
% Parameters: table: contains the data in table.data
% m: the wanted number of features
% beta: the weight which shows how significant the mutual information
% impats between features

%Initialization and variable checking
    assert(isstruct(table),'table is not a struct');
    assert(isnumeric([m,beta]),'m and beta must be numeric');
   % S.data = zeros(length(table.data(:,1)),m);
  
%for each fi in F , compute I( C; fi)
    totalfeatures = length(table.data(1,:));
    FEATURES = table.data(:,1:(totalfeatures-1));
    COST = table.data(:,totalfeatures);
    FCMatrix = findMI(FEATURES,COST);
%find the feature which maximizes I(C;fi). Add it into S 
    index = Index(FCMatrix,max(matrix));
    S.title=table.title(index);
    S.type=table.type(index);
    S.data=FEATURES(:,index);
    %Remove from F and remove the corresponded value in FCMatrix
    FEATURES(:,index)=[];
    FCMatrix(index,:)=[];
%Start a loop until the process finished
    for i = 1 : m
        % find the matrix that holds the MI between features
        % A row of the FFMatrix holds the MI between each feature in
        % FEATURES and one feature in S.data
        FFMatrix = findMI(FEATURES,S.data);
        % find the delta 
        delta = zeros(length(FFMatrix(:,1)),1);
        for j=1 : length(FFMatrix(:,1))
            delta(j) = FCMatrix(j,:) - beta*sum(FFMatrix(j,:));
        end
        %f-th feature be the one that maximizes delta
        f = Index(max(delta));
        %add f-th feature to S 
        S.data = [S.data,FEATURES(:,f)];
        %remove it from FEATURES
        FEATURES(:,f)=[];
        
    end
end

