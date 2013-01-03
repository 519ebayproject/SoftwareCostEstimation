%data = readData('ISBSG[USE].xls');
%data = excludeNaN(data);
%data = encapsulateData(data);

%Cleaned = Preprocess(data);

%CrossValidation(Cleaned);

%Cleaned = Preprocess(data);
%csvwrite('Cleaned(1).csv',Cleaned.data);

%FSRlt = MIFS(Cleaned,9,1);
%csvwrite('FS.csv',FSRlt.data);

ValidationFramework('Desharnais(change).xls',1,25,0.1,2.0,0.05);
%ValidationFramework('ISBSG[USE].xls',1,17,0.1,2.0,0.05);
