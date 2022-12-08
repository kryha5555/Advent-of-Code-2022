clear
clc

M = char(readlines('input.txt')) - '0';

%% Calculate result for both parts
tic
part1 = 0;
part2 = [];

for i = 2:size(M,1)-1
    for j = 2:size(M,2)-1
        top = flip(M(1:i-1,j));
        bottom = M(i+1:end,j);
        left = flip(M(i,1:j-1));
        right = M(i,j+1:end);

        if all(M(i,j) > top) ||  ...
                all(M(i,j) > bottom) || ...
                all(M(i,j) > left ) || ...
                all(M(i,j) > right)
            part1 = part1 + 1;
        end
      
        t = getDistance(top,M(i,j));
        b = getDistance(bottom,M(i,j));
        l = getDistance(left,M(i,j));
        r = getDistance(right,M(i,j));

        part2 = [part2 prod([t b l r])];
    end
end

part1 = part1 + sum(size(M)) + sum(size(M)-2)
toc
part2 = max(part2)
toc

%% Helper function for part 2
function distance = getDistance(treeLine,tree)
    distance = find(treeLine >= tree,1);
    if isempty(distance)
        distance = length(treeLine);
    end
end
