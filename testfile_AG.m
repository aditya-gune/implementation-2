%implementation assignment 2
dir = 'D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2';
%'D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.bagofwords.train'
%'D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.labels.train'


%make dynamic later
n=6000;

i = 0;

%open training file, read data in
tfile = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.bagofwords.train');
lfile = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.labels.train');
tline = fgetl(tfile);
lline = fgetl(lfile);
tData = cell(0,1);
lData = cell(0,1);
while ischar(tline)
    tData{end+1,1} = tline;
    lData{end+1,1} = lline;
    tline = fgetl(tfile);
    lline = fgetl(lfile);
end
tData(:,2) = lData;
fclose(tfile);
fclose(lfile);




