function [ mmre ] = MMRE( ac,ex )
%MMRE mean magnitude of relative error (MMRE). the actual effort should be
%put in the same order as experiment effort
%   
    assert(isvector(ex),'input is not vector');
    assert(length(ac)==length(ex),'unequal length of vectors');
    MRE = abs((ac-ex)./ac);
    mmre = mean(MRE);
end

