clear
clc

M = importdata('input.txt',"\n");

%% Parse input
tic
stacks = strings(1,9);
stackPos = 2:4:length(M{1}); % positions of crate char
i = 1;

while(M{i}(1) ~= ' ')
    for x = 1:length(stackPos)
        if M{i}(stackPos(x)) ~= ' ' % append if crate char
            stacks(x) = stacks(x) + string(M{i}(stackPos(x)));
        end
    end
    i = i + 1;
end

rules = [];

for i = i+1:length(M)
    rules = [rules; str2double(regexp(M{i},'\d*','Match'))];
end

%% Calculate result for both parts
stacks2 = stacks;

for i = 1:length(rules)
    % for part 1
    source = char(stacks(rules(i,2)));
    dest = char(stacks(rules(i,3)));

    % pop whole block to source, reverse and push it to dest
    dest = [flip(source(1:rules(i,1))) dest];
    source = source(rules(i,1)+1:end);

    stacks(rules(i,2)) = string(source);
    stacks(rules(i,3)) = string(dest);

    % for part 2
    source = char(stacks2(rules(i,2)));
    dest = char(stacks2(rules(i,3)));

    % pop whole block to source and push it to dest
    dest = [source(1:rules(i,1)) dest];
    source = source(rules(i,1)+1:end);

    stacks2(rules(i,2)) = string(source);
    stacks2(rules(i,3)) = string(dest);
end

part1 = squeeze(char(stacks));
part1 = part1(1,:)
toc
part2 = squeeze(char(stacks2));
part2 = part2(1,:)
toc