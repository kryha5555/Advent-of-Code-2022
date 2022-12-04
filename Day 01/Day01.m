clear
clc

M = importfile('input.txt');

%% Calculate result for both parts
tic
A = [];
partSum = 0;

for i = 1:length(M)
    if isnan(M(i))
        A(end+1) = partSum;
        partSum = 0;
    else
        partSum = partSum + M(i);
    end
end

part1 = max(A)
toc
part2 = sum(maxk(A,3))
toc