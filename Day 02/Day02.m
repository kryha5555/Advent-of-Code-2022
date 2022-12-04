clear
clc

M = strrep(importfile('input.txt'),' ', '');

%% Helper for scoring
% A - rock - 1
% B - paper - 2
% C - scissors - 3

% X - rock - 1
% Y - paper - 2
% Z - scissors - 3

% win - 6
% draw - 3
% lose - 0

%% Calculate result for both parts
tic
keys = {'AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ'};

values1 = [4, 8, 3, 1, 5, 9, 7, 2, 6];
dict1 = containers.Map(keys,values1);
part1 = 0;

values2 = [3, 4, 8, 1, 5, 9, 2, 6, 7];
dict2 = containers.Map(keys,values2);
part2 = 0;

for i = 1:length(M)
    part1 = part1 + dict1(M(i));
    part2 = part2 + dict2(M(i));
end

part1
toc

part2
toc