clear
clc
format longg

M = importdata('input.txt');

%% Calculate result for part 1
tic
M(:,2) = 1:length(M); % save starting index of each digit
Morig = M; % save input for part 2 processing

for i = 1:length(M) % for each number
    idx = find(M(:,2) == i); % lookup index from 1 to length(M)
    M = circshift(M,-idx+1); % shift so number with index idx is first

    % Pop number
    number = M(1,:);
    M(1,:) = [];

    M = circshift(M,rem(-number(1),length(M))); % shift by number with index idx
    M(end+1,:) = number; % append number at the end of the list
end

idx = find(M(:,1)==0); % get index of number 0
M = circshift(M,-idx+1); % shift so number with value 0 is first

part1 = M(1001) + M(2001) + M(3001)
toc

%% Calculate result for part 2
key = 811589153;
M = Morig * key; % multiply original input by key
M(:,2) = 1:length(M);

for runNumber = 1:10
    for i = 1:length(M)
        idx = find(M(:,2) == i);
        M = circshift(M,-idx+1);

        number = M(1,:);
        M(1,:) = [];

        M = circshift(M,rem(-number(1),length(M)));
        M(end+1,:) = number;
    end
end

idx = find(M(:,1)==0);
M = circshift(M,-idx+1);

part2 = M(1001) + M(2001) + M(3001)
toc