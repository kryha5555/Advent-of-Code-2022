clear
clc

M = importdata('input.txt');
M = cellfun(@split,M,'UniformOutput',false);

%% Calculate directories size
tic
directories = containers.Map();
currentPath = [];

for i = 1:length(M)
    if M{i}{1} == '$'
        if M{i}{2} == "cd" % if changeing directory
            if M{i}{3} == ".." % move out
                currentPath = currentPath(1:end-1);
            else % move in
                currentPath = [currentPath; string(M{i}{3})];
            end
        end
    elseif M{i}{1} ~= "dir" % if file
        for p = 1:length(currentPath) % for each directory in path
            curDir = join(currentPath(1:p),""); % create full path
            if isKey(directories,curDir) % increment if present
                directories(curDir) = directories(curDir) + str2double(M{i}{1});
            else % create new key if not present
                directories(curDir) = str2double(M{i}{1});
            end
        end
    end
end

%% Calculate result for part 1
spaceUsed = cell2mat(directories.values);

% Get sum of spaceUsed values that are <= 100000
part1 = sum(spaceUsed(spaceUsed <= 100000))
toc

%% Calculate result for part 2
maxSpace = 70000000;
requiredSpace = 30000000;
currentSpace = maxSpace - directories("/");
spaceNeeded = requiredSpace - currentSpace;

% Get minimum of spaceUsed values that are >= spaceNeeded
part2 = min(spaceUsed(spaceUsed >= spaceNeeded))
toc