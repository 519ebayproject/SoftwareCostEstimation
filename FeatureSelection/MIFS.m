function [ Out ] = MIFS( table, m, beta )
%Using mutual inforamation feature selection method
% the package InfoTheory by Mo Chen is used to compute mutual information
% Parameters: table: contains the data in table.data
% m: the wanted number of features
% beta: the weight which shows how significant the mutual information
% impats between features

%Initialization and variable checking
    assert(isstruct(table),'table is not a struct');
    assert(isnumeric([m,beta]),'m and beta must be numeric');
   
%disretize the table data after backing up it.
  Copy = table;
  for i = 1:(length(Copy.type)-1)
      if cell2mat(Copy.type(i)) == 'C'
          Copy.data(:,i)=Discretize(Copy.data(:,i),50);
      end
  end
%Initialize FEATURES and COST and restore Copy as original table
    totalfeatures = length(Copy.data(1,:));
    FEATURES.type = Copy.type(:,1:(totalfeatures-1));
    FEATURES.title = Copy.title(:,1:(totalfeatures-1));
    FEATURES.data = Copy.data(:,1:(totalfeatures-1));
    COST = Copy.data(:,totalfeatures);
    Copy = table;
%for each fi in F , compute I( C; fi)
    FCMatrix = findMI(FEATURES.data,COST);
%find the feature which maximizes I(C;fi). Add it into S 
    index = Index(FCMatrix,max(FCMatrix));
    S.title=FEATURES.title(index);S.type=FEATURES.type(index);S.data=FEATURES.data(:,index);
    Out.title=Copy.title(index);Out.type=Copy.type(index);Out.data=Copy.data(:,index);

    %Remove from F and remove the corresponded value in FCMatrix
    FEATURES.data(:,index)=[]; FEATURES.type(:,index)=[]; FEATURES.title(:,index)=[];
    Copy.data(:,index)=[]; Copy.type(:,index)=[]; Copy.title(:,index)=[];
    
    FCMatrix(index,:)=[];
%Start a loop until the process finished
    for i = 1 : m-1
        % find the matrix that holds the MI between features
        % A row of the FFMatrix holds the MI between each feature in
        % FEATURES and one feature in S.data
        FFMatrix = findMI(FEATURES.data,S.data);
        % find the delta 
        delta = zeros(length(FFMatrix(:,1)),1);
        for j=1 : length(FFMatrix(:,1))
            delta(j) = FCMatrix(j,:) - beta*sum(FFMatrix(j,:));
        end
        %f-th feature be the one that maximizes delta
        f = Index(delta,max(delta));
        %add f-th feature to S 
        S.type = [S.type,FEATURES.type(f)];
        S.title = [S.title,FEATURES.title(f)];
        S.data = [S.data,FEATURES.data(:,f)];
        Out.type = [Out.type,Copy.type(f)];
        Out.title = [Out.title,Copy.title(f)];
        Out.data = [Out.data,Copy.data(:,f)];
        %remove it from FEATURES
        FEATURES.type(:,f)=[];FEATURES.title(:,f)=[];FEATURES.data(:,f)=[];
        Copy.type(:,f)=[];Copy.title(:,f)=[];Copy.data(:,f)=[];
        
    end
    Out.type = [Out.type,table.type(length(table.type))];
    Out.title = [Out.title,table.title(length(table.type))];
    Out.data = [Out.data,table.data(:,length(table.type))];
end

