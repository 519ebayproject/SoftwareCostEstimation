function [ mre ] = MRE( actualEffort, estimateEffort )
%MRE Summary of this function goes here
%   Detailed explanation goes here

mre = abs((actualEffort-estimateEffort)/actualEffort);

end

