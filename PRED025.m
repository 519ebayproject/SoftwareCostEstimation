function [ pred ] = PRED025( ac, ex )
%PRED(0.25) The PRED (0.25) is the percent-age of predictions that fall 
% within 25% of the actual value,
%   Detailed explanation goes here
    assert(isvector(ex),'input is not vector');
    assert(length(ac)==length(ex),'unequal length of vectors');
    MRE = abs((ac-ex)./ac);
    cnt025 = 0;
    for i = 1:length(MRE)
        if MRE(i) <= 0.25
        cnt025 = cnt025+1;
        end
    end
    pred = cnt025/length(MRE);

end

