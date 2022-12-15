clear
clc
format longG

M = readlines("input.txt").erase(["Sensor at x=", " y=",...
    "closest beacon is at x="]).replace(": ",",").split(",").double();

%% Calculate result for part 1
tic
sensorX = M(:,1);
sensorY = M(:,2);
beaconX = M(:,3);
beaconY = M(:,4);
manhDist = abs(sensorX - beaconX) + abs(sensorY - beaconY);
row = 2e6;

% Start and end of range covered by sensor on row level
rangeStart = sensorX - manhDist + abs(sensorY - row);
rangeEnd = sensorX + manhDist - abs(sensorY - row);

% If start > end, no coverage on row level
rangeStart(rangeStart > rangeEnd) = [];
rangeEnd(isnan(rangeStart)) = [];

% Omit beacons while counting positions
beaconsInRow = unique(beaconX((beaconY == row)));

part1 = max(rangeEnd) - min(rangeStart) + 1 - size(beaconsInRow,1)
toc

%% Calculate result for part 2
manhSums = zeros(length(M));   % sum of Manhattan distances
sensorDist = zeros(length(M)); % distance between sensors

for i = 1:size(M,1)
    for j = 1:size(M,1)
        manhSums(i,j) = manhDist(i) + manhDist(j);
        sensorDist(i,j) = abs(sensorX(i) - sensorX(j)) + abs(sensorY(i) - sensorY(j));
    end
end

% Get sensors whose range are separated by single space (2 because Manhattan distance)
[sensors, ~] = ind2sub(size(manhSums),find(sensorDist - manhSums == 2));

sensorX = M(sensors,1);
sensorY = M(sensors,2);
beaconX = M(sensors,3);
beaconY = M(sensors,4);
manhDist = manhDist(sensors) + 1; % +1 for outline

for i = 1:length(sensors)
    % Get coordinates of outlines
    x = [sensorX(i) : sensorX(i) + manhDist(i), ... % from sX up to sX+r
        sensorX(i) : sensorX(i) + manhDist(i), ...  % from sX up to sX+r
        sensorX(i) : -1 : sensorX(i) - manhDist(i), ... % from sX down to sX-r
        sensorX(i) : -1 : sensorX(i) - manhDist(i)];    % from sX down to sX-r

    y = [sensorY(i) - manhDist(i) : sensorY(i), ... % from sY-r up to sY
        sensorY(i) + manhDist(i) : -1 : sensorY(i), ... % from sY+r down to sY
        sensorY(i) - manhDist(i) : sensorY(i), ...  % from sY-r up to sY
        sensorY(i) + manhDist(i) : -1 : sensorY(i)];     % from sY+r down to sY

    if i == 1
        xy = [x', y'];
    else
        xy = intersect(xy, [x',y'], 'rows'); % intersect each sensor outline
    end
end

part2 = sum([4e6 1].*xy)
toc