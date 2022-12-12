clear
clc

M = char(readlines('input.txt')) - 'a';

%% Pad array with NaNs to avoid out-of-bounds index
tic
Mpad = NaN * ones(size(M)+2);
Mpad(2:end-1,2:end-1) = M;
M = Mpad;

%% Get positions of start and end
[Ystart, Xstart] = find(M == 'S'-'a');
M(Ystart,Xstart) = 0;

[Yend, Xend] = find(M == 'E' - 'a');
M(Yend,Xend) = 25;

%% Prepare edge sources and targets lists and create digraph
source = strings(0);
target = strings(0);

for y = 2:size(M,1) - 1
    for x = 2:size(M,2) - 1
        % Up 
        if M(y-1,x) - M(y,x) <= 1
            source(end+1) = string(y + "," + x);
            target(end+1) = string((y-1) + "," + x);
        end
        
        % Down
        if M(y+1,x) - M(y,x) <= 1
            source(end+1) = string(y + "," + x);
            target(end+1) = string((y+1) + "," + x);
        end

        % Left
        if M(y,x-1) - M(y,x) <= 1
            source(end+1) = string(y + "," + x);
            target(end+1) = string(y + "," + (x-1));
        end

        % Right
        if M(y,x+1) - M(y,x) <= 1
            source(end+1) = string(y + "," + x);
            target(end+1) = string(y + "," + (x+1));
        end
    end
end

G = digraph(source,target);

%% Calculate result for part 1
part1 = shortestpath(G,string(Ystart + "," + Xstart),string(Yend + "," + Xend));
part1 = length(part1) - 1

%% Calculate result for part 2
% from 'a' we can only move up to 'b'
% 'b's are only in column 2
% only 'a's we have to consider are ones with 'b's adjacent
% other 'a's will not have path leading to 'E'
% to get shortest path, we consider only 'a's in columns 2 and 4 (padded)
[Y, X] = find(M(:,1:4) == 0); 
part2 = zeros(1,length(Y));

for i = 1:length(Y)
    path = shortestpath(G,string(Y(i) + "," + X(i)),string(Yend + "," + Xend));
    part2(i) = length(path);
end

part2 = min(part2) - 1
toc