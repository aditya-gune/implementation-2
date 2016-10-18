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
    i = 1;
    tarray = textscan(tline,'%f');
    for i = 1:size(tarray{i},1)
        tarray = [tarray, tarray{1}(i,1)];
        %tData{end+1,2} = tarray{1}(i,1);
    end
    i = i + 1;
    j = j + 1;
    tarray(1) = [];
    tData{end+1,1} = tarray;
    %t_length = size(tarray);
    %tData{end+1,1:t_length(2)} = tarray(1:t_length(2));
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


%MULTINOMIAL IMPLEMENTATION
    wordcount = zeros(length(dictionary), 2);
    for j = 1:length(tData) 
        disp('-------------');
        disp(j)
        disp(tData(j,2))
        words = tData{j};
        for z=1:size(words,2) %iterate thru matrix
            if strcmp(tData(j,2), 'HillaryClinton')
                if int32(words{z}) > 0
                    wordcount(int32(words{z}),1) = wordcount(int32(words{z}),1) + 1;
                end
            else
                if int32(words{z}) > 0
                    wordcount(int32(words{z}),2) = wordcount(int32(words{z}),2) + 1;
                end
            end
        end %end of this tweet (as a matrix)
    end %end of this element in tData (1 tweet)