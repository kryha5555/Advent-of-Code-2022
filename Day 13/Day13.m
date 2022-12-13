clear
clc

M = importdata('input.txt');
M = replace(M,{'[',']'},{'{','}'});

%% Calculate result for part 1
tic
part1 = zeros(1,length(M)/2);
for i = 1:length(M)/2
    left = eval(M{2*i-1});
    right = eval(M{2*i});
    part1(i) = compare(left,right);
end
part1 = sum(find(part1==1))
toc

%% Calculate result for part 2
M = vertcat(M, '{{2}}', '{{6}}');
n = length(M);

while n > 1
    for i = 1:n-1
        left = eval(M{i});
        right = eval(M{i+1});
        if compare(left,right) == -1
            M([i i+1]) = M([i+1 i]);
        end
    end
    n = n-1;
end

decoderStart = ismember(M,'{{2}}');
decoderEnd = ismember(M,'{{6}}');

part2 = find(decoderStart | decoderEnd);
part2 = prod(part2)
toc

%% Helper function
function y = compare(L,R)
% y =  1 - in right order
% y = -1 - in not right order
% y =  0 - order not yet determined
y = 0; 

for i = 1:max(length(L),length(R))
    if i > length(L) % left list runs out of items first
        y = 1; % right order
        break;
    elseif i > length(R) % right list runs out of items first
        y =  -1; % not right order
        break
    end

    if ~iscell(L{i}) && iscell(R{i}) % L is integer, R is list
        L{i} = L(i); % convert the integer to a one-value list
    end

    if iscell(L{i}) && ~iscell(R{i}) % L is list, R is integer
        R{i} = R(i); % convert the integer to a one-value list
    end

    if ~iscell(L{i}) && ~iscell(R{i}) % both values are integers
        if L{i} > R{i} % L is higher than R
            y = -1; % not right order
        elseif L{i} < R{i} % L is lower than R
            y = 1; % right order
            break;
        end
    elseif isempty(L) && ~isempty(R)
        y = 1; % right order
    elseif ~isempty(L) && isempty(R)
        y = -1; % not right order
    else
        y = compare(L{i},R{i});
    end
    if y ~= 0
        break
    end
end
end
