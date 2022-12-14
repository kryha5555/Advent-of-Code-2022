clear
clc

M = readlines('input.txt');

%% Create terrain
tic
terrain = [];

for i = 1:length(M) % for each input line
    paths = double(split(split(M(i)," -> "),",")) + 1;
    for p = 1:size(paths,1)-1 % construct each path between points
        terrain(min(paths(p:p+1,2)):max(paths(p:p+1,2)), ...
            min(paths(p:p+1,1)):max(paths(p:p+1,1))) = 1;
    end
end

abyss = size(terrain,1);

% Add free space to the right side of terrain
% Expansion needs at most size(terrain,1) free space to the right
terrain = [terrain zeros(abyss)];

%% Calculate result for part 1
sandUnits = 0;

while true % per sand unit
    startPos = [0, 501];
    while true % per sand unit step
        if startPos(1) == abyss % exit condition
            break
        end

        if terrain(startPos(1)+1,startPos(2)) == 0
            newPos = startPos + [1, 0];  % move down
        elseif terrain(startPos(1)+1,startPos(2)-1) == 0
            newPos = startPos + [1, -1]; % move down-left
        elseif terrain(startPos(1)+1,startPos(2)+1) == 0
            newPos = startPos + [1, 1];  % move down-right
        end

        if newPos(1) == startPos(1) % if position was not updated
            break % next sand unit
        else
            startPos = newPos;
        end
    end

    if startPos(1) == abyss % if reached bottom line
        break
    else % update terrain 
        terrain(startPos(1),startPos(2)) = 1;
        sandUnits = sandUnits + 1;
    end
end

part1 = sandUnits
toc