clear
clc
close all
format longG

M = readlines('input.txt');

%% Calculate result for both parts
tic
monkeys = (length(M)+1)/7;
items = cell(1,monkeys);
operation = strings(1,monkeys);
operand = strings(1,monkeys);
test = zeros(1,monkeys);
iftrue = zeros(1,monkeys);
iffalse = zeros(1,monkeys);

for i = 1:monkeys
    idx = 7*(i-1)+1;
    items{i} = str2double(regexp(M(idx+1),'\d*','Match'));
    opp = split(M(idx+2));
    operation(i) = opp(6);
    operand(i) = opp(7);
    test(i) = str2double(regexp(M(idx+3),'\d*','Match'));
    iftrue(i) = str2double(regexp(M(idx+4),'\d*','Match'));
    iffalse(i) = str2double(regexp(M(idx+5),'\d*','Match'));
end
toc

part1 = monkeyBusiness(monkeys,items,operation,operand,test,iftrue,iffalse,1,20)
toc
part2 = monkeyBusiness(monkeys,items,operation,operand,test,iftrue,iffalse,2,10000)
toc

%% Helper function
function score = monkeyBusiness(monkeys,items,operation,operand,test,iftrue,iffalse,part, rounds)
score = zeros(1,monkeys);
LCM = prod(test);
operand = str2double(operand);

for rnd = 1:rounds
    for m = 1:monkeys
        for i = 1:length(items{m})
            % Inspect item
            score(m) = score(m) + 1;
            
            % Change worry level
            if operation(m) == "*"
                if isnan(operand(m))
                    new = items{m}(i) * items{m}(i);
                else
                    new = items{m}(i) * operand(m);
                end
            else
                new = items{m}(i) + operand(m);
            end
            
            % Manage worry level
            if part == 1
                items{m}(i) = floor(new/3);
            else
                items{m}(i) = mod(new,LCM);
            end
            
            % Test worry level and throw item
            if mod(items{m}(i), test(m)) == 0
                items{iftrue(m)+1}(end+1) = items{m}(i);
            else
                items{iffalse(m)+1}(end+1) = items{m}(i);
            end
        end
        items{m}(:) = [];
    end
end

score = prod(maxk(score,2));
end