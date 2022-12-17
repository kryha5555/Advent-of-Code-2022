clear
clc

M = readlines("input.txt");

%% Parse input into flow rates and exit valves
tic
flowRates = dictionary();
exitValves = dictionary();

for line = M'
    line = replace(line,","," ").split();
    source = line(2);
    rate = char(line(5));
    rate = str2double(rate(6:end-1));
    exits = line(10:end);

    flowRates(source) = rate;
    exitValves(source) = {exits};
end

toc

%% Calculate distances between rooms with flowRate > 0 (and starting room)
positiveRooms = flowRates.keys;
positiveRooms = positiveRooms(flowRates.values > 0 | flowRates.keys == "AA");

roomDistances = dictionary();

for startRoom = flowRates.keys'
    if isempty(find(positiveRooms == startRoom, 1))
        continue % skip rooms with 0 flowRate (excluding starting room)
    end

    current = startRoom;
    next = [];
    distance = 0;

    roomDistances(startRoom + startRoom) = 0;

    while ~isempty(current)
        distance = distance + 1;
        for pos = current'
            e = exitValves(pos);
            e = e{1};
            for newPos = e'
                if ~isKey(roomDistances,startRoom + newPos)
                    roomDistances(startRoom + newPos) = distance;
                    next = [next; newPos];
                end
            end
        end
        current = next;
        next = [];
    end
end

toc

%% Calculate result for part 1
[part1,~] = findBestTotalFlow("AA", 30, [], positiveRooms,roomDistances,flowRates)
toc

%% Calculate result for part 2
[part2a,valves] = findBestTotalFlow("AA", 26, [], positiveRooms,roomDistances,flowRates);

positiveRooms = setdiff(positiveRooms,valves); % remove visited rooms from considered room list
flowRates(valves) = 0; % set flowRate of visited rooms to 0

[part2b,~] = findBestTotalFlow("AA", 26, [], positiveRooms,roomDistances,flowRates);

part2 = part2a + part2b
toc

%% Traveral function
function [bestFlow, valves] = findBestTotalFlow(currentRoom, time, seenRooms, positiveRooms,roomDistances,flowRates)

seenRooms = [seenRooms; currentRoom];

for s = seenRooms'
    positiveRooms(positiveRooms==s) = []; % remove seen nodes from target nodes
end

valves = [];
bestFlow = 0;

for room = positiveRooms'
    timeLeft = time - roomDistances(currentRoom + room) - 1;

    if timeLeft > 0
        flow = flowRates(room) * timeLeft;
        [temp,valves] = findBestTotalFlow(room, timeLeft, seenRooms, positiveRooms,roomDistances,flowRates);
        valves = [valves; seenRooms];
        flow = flow + temp;

        if flow > bestFlow
            bestFlow = flow;
        end
    end
end
end
