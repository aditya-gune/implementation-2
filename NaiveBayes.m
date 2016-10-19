%implementation assignment 2
%Aditya Gune, Laurel Hopkins, Alex Turner

%make dynamic later
n=6000;
bernoulli = 0;
mult = 1;
i = 0;

%open training file, read data in
tfile = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.bagofwords.train');
testfile = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.bagofwords.dev');
testlabels = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.labels.dev');
lfile = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.labels.train');


tline = fgetl(tfile);
testlabelline = fgetl(testlabels);
testline = fgetl(testfile);
lline = fgetl(lfile);


tData = cell(0,1);
testData = cell(0,1);
lData = cell(0,1);
testlabelarray = cell(0,1);

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

while ischar(testline)
    i = 1;
    testarray = textscan(testline,'%f');
    for i = 1:size(testarray{i},1)
        testarray = [testarray, testarray{1}(i,1)];

    end
    i = i + 1;
    j = j + 1;
    testarray(1) = [];
    testData{end+1,1} = testarray;
    testline = fgetl(testfile);
end
fclose(testfile);

while ischar(testlabelline)
    testlabelarray{end+1,1} = testlabelline;
    testlabelline = fgetl(testlabels);
end
fclose(testlabels);

%read in dictionary
fid = fopen('D:\Aditya\Desktop\School\OSU\MS\Term 1\CS534 - Machine Learning\Implementation 2\clintontrump.vocabulary');
dline = fgetl(fid);
dictionary = cell(0,2);
while ~feof(fid)
    tline = fgetl(fid);
    tline = textscan(tline,'%s\t%s\t%s');
    dictionary(end+1,1:2) = cat(1,tline{:});
end

%%%%%MODIFY THIS BLOCK TO RUN PROGRAM%%%%%%%%%%%%%%%%%%%%%%%%%

%TRAIN ON BERNOULLI
[wc] = trainBernoulli(tData, dictionary, tweetCount_H, tweetCount_D);

%TRAIN ON MULTINOMIAL
[wc, wc_H, wc_D, log_pdist_H, log_pdist_D] = trainMultinomial(tData, dictionary);

[tweetCount_H, tweetCount_D] = countTweets(tData);
testResults = testFunction(testData, wc, bernoulli, tweetCount_H, tweetCount_D, testlabelarray);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%count tweets and calc prior
function [tweetCount_H, tweetCount_D] = countTweets(tData) 
    tweetCount_H = 0;
    tweetCount_D = 0;
    for j = 1:length(tData) 
        words = tData{j};
        if strcmp(tData(j,2), 'HillaryClinton')
            tweetCount_H = tweetCount_H + 1;
        else
            tweetCount_D = tweetCount_D + 1;
        end
    end
end


%BERNOULLI IMPLEMENTATION
function [wordcount] = trainBernoulli(tData, dictionary, tweetCount_H, tweetCount_D)
    wordcount = zeros(length(dictionary), 2);
    log_pdist_H = 0;
    log_pdist_D = 0;
    for j = 1:length(tData) 
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
    
    %get prob distribution
    for x=1:length(wordcount)
        %populate p(x_i|y=hillary)
        num = wordcount(x,1); %laplace smoothing
        %denom = tweetCount_H;
        %denom = denom(1);
        wordcount(x,3) = (num+1)/(tweetCount_H + 2); %Laplace smoothing
        log_pdist_H = log_pdist_H + log(wordcount(x,3));
        
        %populate p(x_i|y=trump)
        num = wordcount(x,2); 
        %denom = tweetCount_D;
        %denom = denom(1);
        wordcount(x,4) = (num + 1)/(tweetCount_D + 2); %Laplace smoothing
        log_pdist_D = log_pdist_D + log(wordcount(x, 4));
        
    end
    
end

%MULTINOMIAL IMPLEMENTATION
function [wordcount, wc_H, wc_D, log_pdist_H, log_pdist_D] = trainMultinomial(tData, dictionary)
    wc_H = 0; %total # of words tweeted by Hillary
    wc_D = 0; %total # of words tweeted by Trump
    log_pdist_H = 0;
    log_pdist_D = 0;
    wordcount = zeros(length(dictionary), 4);
    for j = 1:length(tData) 
        words = tData{j};
        if strcmp(tData(j,2), 'HillaryClinton')
            wc_H = wc_H + size(tData{j},2);
        else
            wc_D = wc_D + size(tData{j},2);
        end
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
    %get prob distribution
    for x=1:length(wordcount)
        %populate p(x_i|y=hillary)
        num = wordcount(x,1) + 1; %laplace smoothing
        denom = (wc_H + length(wordcount));
        denom = denom(1);
        wordcount(x,3) = num/denom(1);
        log_pdist_H = log_pdist_H + log(wordcount(x,3));
        
        %populate p(x_i|y=trump)
        num = wordcount(x,2) + 1; %laplace smoothing
        denom = (wc_D + length(wordcount));
        denom = denom(1);
        wordcount(x,4) = num/denom(1);
        log_pdist_D = log_pdist_D + log(wordcount(x, 4));
        
    end
    
end
    
function testResults = testFunction(testData, wc, trainingModel, tweetCount_H, tweetCount_D, testlabelarray)
    fid = fopen('results.txt', 'w');
    
    testResults = zeros(length(testData),1);
    numCorrect = 0;
    prob_H = 1;
    prob_D = 1;
    owner = '';
    %Bernoulli = 0; Mult = 1
    if trainingModel < 1
        smoothing = 0.5;
    else
        smoothing = 0.5;  %change for multinomial
    end
    for j = 1:length(testData)
        prob_H = 0;
    	prob_D = 0;
        words = testData{j};
        label = testlabelarray{j};
        %go thru one tweet and accumulate probs
        for z=1:size(words,2)
            if words{z} > length(wc)
                prob_H = prob_H + log(smoothing);
            else
                prob_H = prob_H + log(wc(words{z}, 3));
                prob_D = prob_D + log(wc(words{z}, 4));
            end
        end
        prior_H = log(tweetCount_H/length(wc));
        prob_H = prob_H + prior_H;
        
        prior_D = log(tweetCount_D/length(wc));
        prob_D = prob_D + prior_D;
        
        if prob_H > prob_D
            owner = 'HillaryClinton';
        else
            owner = 'realDonaldTrump';
        end       
        if strcmp(owner, label) > 0
            testResults(j) = 1;
            numCorrect = numCorrect +1;
        end
        fprintf(fid, '%s\n', owner);
    end
disp(numCorrect/length(testData));
fclose(fid);
end