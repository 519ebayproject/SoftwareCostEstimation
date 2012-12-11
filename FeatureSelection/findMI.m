function [ MIMatrix ] = findMI( F, C )
%FINDMI: find the MIMatrix between each column in F and C
%F: indicates the feature set 
%C: indicates the cost set but the number of columns in C will probably 
% be more than 1
    MIMatrix = zeros(length(F(1,:)),length(C(1,:)));
    for i=1 : length(C(1,:))
        for j=1 : length(F(1,:))
            MIMatrix(j,i)=mutualInformationD(F(:,j),C(:,i));
        end
    end

end

