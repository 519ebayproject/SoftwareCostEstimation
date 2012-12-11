function [ data ] = excludeNaN( data )
    [m,n]=size(data);
   % idx = 0;
    
    %initialize the loop variable
    i=1;
    
    % traverse all rows
    while(i<=m)
        % for each row, traverse all columns
        for j=1:n
            temp = cell2mat(data(i,j));
           if( isnan(temp))
               % if contains NaN cell, then delete the whole row
               data(i,:)=[];
              % idx=idx+1;
               %disp(i);
               %disp(j);
               
               % since one row has been deleted, adjust the index
              i=i-1;
              m=m-1;     
              
              break;
           end
        end
        i=i+1;
    end
   % disp(idx);
end

