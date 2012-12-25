function [ mmre ] = MMRE( ac,est )
%MMRE mean magnitude of relative error (MMRE). the actual effort should be
%put in the same order as experiment effort
%   
    assert(isvector(est),'input is not vector');
    assert(length(ac)==length(est),'unequal length of vectors');
    MRE = abs((ac-est)./ac);
    mmre = mean(MRE);
end

