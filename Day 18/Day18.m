clear
clc

M = str2double(readlines("input.txt").split(','));

%% Calculate result for part 1
tic
directions = [[0 0 1]; [0 0 -1]; [0 1 0]; [0 -1 0]; [1 0 0]; [-1 0 0]];
part1= 0;

for cube = M' % for each cube in input
    for d = directions' % for each adjacent cube
        newCube = (cube + d)'; % calculate adjacent cube position
        if ~isMember3D(newCube,M) % if adjacent cube is not in input
            part1 = part1 + 1;
        end
    end
end

part1
toc

%% Prepare data for part 2
% Get bounding box that is larger from min/max by 1
[minBound, maxBound] = bounds(M);
minBound = minBound - 1;
maxBound = maxBound + 1;

waterCubes = [NaN NaN NaN];
cubesQueue = minBound;

while ~isempty(cubesQueue)
    % Pop queue to current
    currentCube = cubesQueue(1,:);
    cubesQueue = cubesQueue(2:end,:);

    % Skip if already checked
    if isMember3D(currentCube,waterCubes)
        continue
    end

    % Push current to water
    waterCubes(end+1,:) = currentCube;

    % For each cube adjacent to currentCube
    for d = directions'
        newCube = currentCube + d';

        % Skip if newCube is out of bounds
        if ~all([minBound <= newCube, newCube <= maxBound])
            continue
        end

        % Enqueue newCube if not in input
        if ~isMember3D(newCube,M)
            cubesQueue(end+1,:) = newCube;
        end
    end
end

% Prepare 3-D rectangular space bounded by [minBound, maxBound] 
M2 = []; 
[X, Y, Z] = ndgrid(minBound(1):maxBound(1),minBound(2):maxBound(2),minBound(3):maxBound(3));
cubesGrid = [X(:), Y(:), Z(:)];

% If cube is not water, it must be solid block
for cube = cubesGrid'
    if ~isMember3D(cube',waterCubes)
        M2(end+1,:) = cube';
    end
end

%% Calculate result for part 2
% Rerun same code as in part 1, considering only exterior cube sides 
part2 = 0;

for cube = M2' 
    for d = directions'
        newCube = (cube + d)';
        if ~isMember3D(newCube,M2)
            part2 = part2 + 1;
        end
    end
end

part2
toc

%% Helper function
% Faster version of ismember() function
% Source, adjusted to 3-D:
% https://www.mathworks.com/matlabcentral/answers/7434-find-vector-in-matrix
function p = isMember3D(x,A)
p = any(A(:,1) == x(1) & A(:,2) == x(2) & A(:,3) == x(3));
end