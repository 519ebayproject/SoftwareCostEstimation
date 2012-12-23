data = readData('ISBSG[USE].xls');
data = excludeNaN(data);
data = encapsulateData(data);

Cleaned = Preprocess(data);

CrossValidation(Cleaned);

%Cleaned = Preprocess(data);
%csvwrite('Cleaned(1).csv',Cleaned.data);

%FSRlt = MIFS(Cleaned,9,1);
%csvwrite('FS.csv',FSRlt.data);

