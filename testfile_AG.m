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

%read in dictionary
fid = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.vocabulary');
dline = fgetl(fid);
dictionary = cell(0,2);
while ~feof(fid)
    tline = fgetl(fid);
    tline = textscan(tline,'%s\t%s\t%s');
    dictionary(end+1,1:2) = cat(1,tline{:});
end

train_Multinomial(dictionary, tData);

function train_Multinomial(dictionary, tData)
    isH = sum(sum(strcmp(tData, {'HillaryClinton'}),2));
    HTweets = []
    DTweets = []
    for j = 1:length(tData)
        if findstr(tData{j}, 'HillaryClinton')
            disp('found')
        end 
    end
    %prior_H = isH/length(tData);
    %prior_D = ~prior_H;
    cProb = zeros(length(dictionary), 3);
    for i = 1:length(dictionary)
        targetWord = dictionary(i);
        for j = 1:length(tData)
            %if tweet is hillary's
            if 
        end
        
    end
    
end