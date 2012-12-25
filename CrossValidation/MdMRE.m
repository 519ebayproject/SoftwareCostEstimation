function [ mdmre ] = MdMRE( ac, est )
%MDMRE Summary of this function goes here
%   Detailed explanation goes here
    assert(isvector(est),'input is not vector');
    assert(length(ac)==length(est),'unequal length of vectors');
    MRE = abs((ac-est)./ac);
    mdmre = median(MRE);

end

