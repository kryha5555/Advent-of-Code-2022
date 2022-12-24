clear
clc

M = char(readlines("input.txt"));

%% Prepare grid
tic
walls = [];
blizzards = [];

% Make it so first walkable tile in grid is on (0,0) for easy blizzard modulo
for y = 1:size(M,1)
    for x = 1:size(M,2)
        if M(y,x) == '#'
            walls(end+1,:) = [x-2, y-2];
        elseif M(y,x) == '>'
            blizzards(end+1,:) = [x-2, y-2, 1, 0];
        elseif M(y,x) == '<'
            blizzards(end+1,:) = [x-2, y-2, -1, 0];
        elseif M(y,x) == '^'
            blizzards(end+1,:) = [x-2, y-2, 0, -1];
        elseif M(y,x) == 'v'
            blizzards(end+1,:) = [x-2, y-2, 0, 1];
        end
    end
end

maxX = max(walls(:,1));
maxY = max(walls(:,2));

% Add walls on top of start and on bottom of exit
walls = [walls; -1 -2; 0 -2; 1 -2;];
walls = [walls;  maxX-1, maxY+1; maxX, maxY+1; maxX+1, maxY+1];
toc

%% Traverse grid 
startPoint = [0, -1];
endPoint = [maxX-1, maxY];
movements = [1,0; 0,1; -1,0; 0,-1; 0,0];

validPositions = startPoint;
goalPoints = [endPoint; startPoint; endPoint];

time = 0;
minutes = zeros(size(goalPoints));

% Traverse until there are no goals
while ~isempty(goalPoints)
    time = time + 1;

    % Calculate position of each blizzard at 'time' step
    currentBlizzards = zeros(size(blizzards,1),2);
    for i = 1:length(blizzards)
        currentBlizzards(i,:) = [mod(blizzards(i,1) + time * blizzards(i,3),maxX)...
            mod(blizzards(i,2) + time * blizzards(i,4),maxY)];
    end
  
    % Calculate each valid position at 'time' step
    newPositions = zeros(size(validPositions,1)*size(movements,1),2);
    for posIdx = 1:size(validPositions,1)
        for movIdx = 1:size(movements,1)
            newPositions((posIdx - 1) * size(movements,1) + movIdx,:) = ...
                [validPositions(posIdx,1) + movements(movIdx,1), ...
                validPositions(posIdx,2) + movements(movIdx,2)];
        end
    end

    % Only consider unique coordinates
    currentBlizzards = unique(currentBlizzards,'rows');
    newPositions = unique(newPositions,'rows');

    % Remove invalid (blizzards or walls) positions
    validPositions = setdiff(setdiff(newPositions,currentBlizzards,'rows'),walls,'rows');

    % If goal is in valid positions list
    if ismember(goalPoints(1,:),validPositions,'rows')
        % Pop goal and start next iteration from it
        validPositions = goalPoints(1,:);
        goalPoints(1,:) = [];
        
        % Save results for display
        minutes(find(minutes==0,1)) = time;
        toc
    end
end

%% Display results
part1 = minutes(1)
assert(part1 == 286)
part2 = minutes(3)
assert(part2 == 820)
toc