clear
clc
close all

M = char(readlines('input.txt'));

%% Prepare board
tic
rocks = {[0 1 2 3];         % '-'
    [1 1j 1+1j 2+1j 1+2j];  % '+'
    [0 1 2 2+1j 2+2j];      % '_|'
    [0 1j 2j 3j];           % '|'
    [0 1 1j 1+1j]};         % '■'

chamber = [0-1j, 1-1j, 2-1j, 3-1j, 4-1j, 5-1j, 6-1j];

%% Calculate result for part 1
i = 0;
max_y = -1;
rock = 0;
coeffTable = [];
n1 = 2022;
n2 = 1000000000000;

while true
    if mod(rock,5) == 0 && mod(i,length(M)) == 18
        % Save rock number and height at beginning of cycle
        coeffTable = [coeffTable; rock max_y];

        if size(coeffTable,1) == 2
            break % only need 2 pairs of (x,y) to extrapolate f(x) = ax+b
        end
    end

    offset = complex(2, max_y + 4); % offset for each rock
    rockPos = offset + rocks{mod(rock,5) + 1}; % -1 and +1 due to 1-indexing

    while true
        moveDirection = M(mod(i,length(M)) + 1); % -1 and +1 due to 1-indexing
        i = i + 1;

        if moveDirection == '>'
            rockPosNew = rockPos + 1; % move right
        else
            rockPosNew = rockPos - 1; % move left
        end

        if all([0 <= real(rockPosNew) real(rockPosNew) < 7]) && ...
                all(~ismember(rockPosNew,chamber))
            rockPos = rockPosNew; % update if horizontal position is valid
        end

        rockPosNew = rockPos - 1j; % move down

        if all(~ismember(rockPosNew,chamber))
            rockPos = rockPosNew; % update if vertical position is valid
        else
            break % else next rock
        end
    end

    chamber = [chamber, rockPos]; % using unique() makes it slower, even though it is more logical
    max_y = max(imag(chamber));

    if rock == n1-1
        part1 = max_y + 1 % get result for part 1
        toc
    end

    rock = rock + 1;
end

%% Calculate result for part 2
% Use saved values to extrapolate as height = a * rock + b 
coeffs = polyfit(coeffTable(:,1), coeffTable(:,2),1);
part2 = floor(coeffs(1) * (n2-1) + coeffs(2)) 

toc