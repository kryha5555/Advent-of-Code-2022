clear
clc
close all

M = readlines('input.txt');

%% Calculate result for part 1
tic
V = [];

for i = 1:length(M)
    if M(i) == "noop"
        V(end+1) = 0;
    else
        addx = split(M(i));
        V(end+[1,2]) = [0; str2double(addx(2))];
    end
end

X = cumsum([1 V]);
part1 = 0;

for i = 20:40:220
    part1 = part1 + i*X(i);
end

part1
toc

%% Calculate result for part 2
B = zeros(1,240);

for i = 1:length(B)
    pos = mod(i-1,40);
    if any([pos-1 pos pos+1] == X(i))
        B(i) = 1;
    end
end

part2 = reshape(B,40,6)';
toc

f = figure('Name','Part 2','NumberTitle','off');
imagesc(part2);
x = get(f,'position');
f.Position = [x(1:2) 500 100];
toc