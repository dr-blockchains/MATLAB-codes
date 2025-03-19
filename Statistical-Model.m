clc;clear all; load 'Data.mat';
%% The Lexicon:
Lexicon = {'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12'};

m = length(Lexicon);

% The 1-grams:
N1grams = Lexicon;

% The 2-grams:
N2grams = cell(m,m);
for i=1:m
    for j=1:m
        N2grams{i,j} = [Lexicon{i} '-' Lexicon{j}];
    end
end

% The 3-grams:
N3grams = cell(m,m,m);
for i=1:m
    for j=1:m
        for k=1:m
            N3grams{i,j,k} = [Lexicon{i} '-' Lexicon{j} '-' Lexicon{k}];
        end
    end
end

% Decide n:
Ngrams = N2grams
g = length(Ngrams(:));

%% Decide which source of data to use:
Day = floor(AG_Dates);
Act = AG_Actions;

nThreats = length (Day);
if(nThreats~=length(Act))
    error('Data are inconsistent.');
end

% Days start at 1;
Day = Day - Day(1) + 1;

% Number of days:
nDays = Day(end);

%% Sort + Straw man:

Total = zeros(g,3);
Daily = zeros(nDays,g);

for i=1:g
    for day=1:nDays
        Daily(day,i) = sum(cellfun(@length,strfind(Act(Day==day),Ngrams{i})));    
    end;
    
    Total(i,1) = sum(Daily(1:floor(nDays/2),i));
    Total(i,2) = sum(Daily(floor(nDays/2)+1:nDays,i));
    Total(i,3) = sum(Daily(:,i));
end

[Total,Order] = sortrows(Total,3);
Total = flipud(Total); Order = flipud(Order);
Ngrams = Ngrams(Order);
Daily=Daily(:,Order);

% The change in repetition from the frist half to the second half:
Differences = Total(:,2)-Total(:,1);

% The proportion repetition from the frist half to the second half:
Ratios = Total(:,2)./Total(:,1);

% Percentage Change:
Percentages = (Total(:,2)-Total(:,1))./Total(:,1);

%% Time window and plots:

win = 30;
lastday = (nDays - win + 1);
Diff = zeros(lastday,g);
DiffWin = zeros(lastday,g);

Reps=zeros(lastday,g);
for i=1:g
    for day = 1:lastday
        
        % Number of occurances in the window time
        Reps(day,i) = sum(Daily( day:day+win-1 ,i));
        
        left  = sum(Daily(1:day , i ))/day;
        right = sum(Daily(day+1:end, i ))/(nDays-day);
        
        % The difference between averages before and after.
        Diff(day,i)=right-left;        
    end
    
    DiffWin(win+1:end,i) = (Reps(win+1:end,i) - Reps(1:end-win,i))./win;
    
    if i>20 
        continue;
    end
    
    figure;
    subplot(2,1,1); 
    plot(Reps(:,i));
    title(['Ngram = ' Ngrams{i}]);
        
    subplot(2,1,2); 
    plot(Diff(:,i),'k');
    hold on;
    plot(DiffWin(:,i));
    title('Changes in the average number of occurances');
end

%% Distances according to correlations:

[R, P] = corr(Reps);
[Rdiff ,Pdiff] = corr(Diff);
[Rdiffwin ,Pdiffwin] = corr(DiffWin);

% F(win) = getframe;
% movie(F,20);
% movie2avi(F,'windows.avi');
