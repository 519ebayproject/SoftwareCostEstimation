function [ data ] = readData( filename )
[ndata,txt,data] = xlsread(filename,1);
end

