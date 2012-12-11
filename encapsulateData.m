function [ output ] = encapsulateData( data )
% extract titles
output.title = data(1,:);

%delete titles
data(1,:)=[];

% extract data
output.data = data;

%get info about data type
[m,n]=size(data);
output.type = output.title;   % do not know how to initialize a char matrix
%traverse all columns
for i=1:n
   temp = cell2mat(data(2,i));  
   disp(temp);
   if(ischar(temp))
       output.type(1,i)={'D'};
   end
   if(isfloat(temp))
       output.type(1,i)={'C'};
   end
    
end



end

