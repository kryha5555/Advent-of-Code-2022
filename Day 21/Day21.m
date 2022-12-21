clear
clc
format longg

M = readlines('input.txt').replace(": ", " = ");

%% Prepare for processing
tic
% Get variable names that makes up root 
rootIdx = find(contains(M,"root = ")==1);
rootParts = split(M(rootIdx));
rootParts = rootParts([3,5]);

% Get original value of humn
humnIdx = find(contains(M,"humn = ")==1);
origHumn = split(M(humnIdx));
origHumn = str2double(origHumn(3));

% Replace humn by 1j for part 2 processing
M(humnIdx) = "humn = 1j";

% Add semicolon to suppress displays
M = M + ";";

%% Calculate result for part 1
% Evaluate expressions in loop untill all are processed
isDone = false;

while ~isDone
    isDone = true;

    % For each expression in input
    for i = 1:length(M)
        try
            % If successful, remove expression from input
            eval(M(i));
            M(i) = missing;
        catch
            % If not successful, skip and process in next loop
            isDone = false;
        end
    end
    
    % Clear successful expressions
    M(ismissing(M)) = [];
end

% Substitute imaginary unit for original humn value
part1 = real(root) + imag(root)*origHumn
assert(part1 == 170237589447588)
toc

%% Calculate result for part 2
% Assume that first variable in root expression is real and second is imaginary
R = eval(rootParts(1));
I = eval(rootParts(2));

% Swap R and I if first is imaginary and second is real
if isreal(I)
    [I, R] = deal(R,I);
end

% Substitute imaginary unit for value that satifies R == I equation 
part2 = (R-real(I))/imag(I)
assert(part2 == 3712643961892)
toc