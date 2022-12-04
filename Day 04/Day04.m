clear
clc

M = importfile('input.txt');

%% Calculate result for both parts
tic
part1 = 0;
part2 = 0;

for i = 1:length(M)
    if M(i,1) >= M(i,3) && M(i,2) <= M(i,4) || ...
            M(i,3) >= M(i,1) && M(i,4) <= M(i,2)
        part1 = part1 + 1;
    end
    
    if ~isempty(intersect(M(i,1):M(i,2),M(i,3):M(i,4)))
        part2 = part2 + 1;
    end
end

part1
toc
part2
toc