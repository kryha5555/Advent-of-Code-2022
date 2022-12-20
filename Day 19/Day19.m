clear
clc

M = readlines("input.txt").replace(':', ' ').split();
M = str2double([M(:,2), M(:,7) M(:,13) M(:,19) M(:,22) M(:,28) M(:,31)]);

%% Generate result for part 1
tic
trials = 500000;
part1 = zeros(1,size(M,1));

for runNumber = 1:size(M,1)
    rule = num2cell(M(runNumber,:));
    geodes = zeros(1,trials);

    for i = 1:trials
        if ~mod(i,100000)
            fprintf("%d: %d/%d (%.2f%%)\n",runNumber,i,trials,i/trials*100);
        end
        geodes(i) = generateGeode(rule, 24);
    end

    part1(runNumber) = runNumber * max(geodes);
end

part1 = sum(part1)
toc

%% Generate result for part 2
tic
trials = 3000000;
part2 = zeros(1,3);

for runNumber = 1:3
    rule = num2cell(M(runNumber,:));
    geodes = zeros(1,trials);

    for i = 1:trials
        if ~mod(i,100000)
            fprintf("%d: %d/%d (%.2f%%)\n", runNumber, i,trials,i/trials*100);
        end
        geodes(i) = generateGeode(rule, 32);
    end

    part2(runNumber) = max(geodes);
end

part2 = prod(part2)
toc

%% Helper function
function geode = generateGeode(rule, time)
[~, ruleOre, ruleClay, ...
    ruleObsidianOre, ruleObsidianClay, ...
    ruleGeodeOre, ruleGeodeObsidian] = deal(rule{:});

ore = 0;
clay = 0;
obsidian = 0;
geode = 0;
oreRobots = 1;
clayRobots = 0;
obsidianRobots = 0;
geodeRobots = 0;

getOreRobot = false;
getClayRobot = false;
getObsidianRobot = false;
getGeodeRobot = false;

for i = 1:time
    rnd = rand();

    if ore >= ruleGeodeOre && obsidian >= ruleGeodeObsidian
        ore = ore - ruleGeodeOre;
        obsidian = obsidian - ruleGeodeObsidian;
        getGeodeRobot = true;
    elseif rnd <= 0.3 && ore >= ruleOre
        ore = ore - ruleOre;
        getOreRobot = true;
    elseif rnd <= 0.7 && ore >= ruleObsidianOre && clay >= ruleObsidianClay
        ore = ore - ruleObsidianOre;
        clay = clay - ruleObsidianClay;
        getObsidianRobot = true;
    elseif rnd <= 0.9 && ore >= ruleClay
        ore = ore - ruleClay;
        getClayRobot = true;
    end

    ore = ore + oreRobots;
    clay = clay + clayRobots;
    obsidian = obsidian + obsidianRobots;
    geode = geode + geodeRobots;

    if getGeodeRobot
        getGeodeRobot = false;
        geodeRobots = geodeRobots + 1;
    elseif getObsidianRobot
        getObsidianRobot = false;
        obsidianRobots = obsidianRobots + 1;
    elseif getClayRobot
        getClayRobot = false;
        clayRobots = clayRobots + 1;
    elseif getOreRobot
        getOreRobot = false;
        oreRobots = oreRobots + 1;
    end
end
end