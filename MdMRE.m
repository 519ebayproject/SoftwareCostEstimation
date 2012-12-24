function [ mdmre ] = MdMRE( ac, ex )
%MDMRE Summary of this function goes here
%   Detailed explanation goes here
    assert(isvector(ex),'input is not vector');
    assert(length(ac)==length(ex),'unequal length of vectors');
    MRE = abs((ac-ex)./ac);
    mdmre = median(MRE);

end

