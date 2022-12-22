clear
clc
format longg

M = readlines("input.txt");

%% Prepare grid
tic
gridChar = char(M(1:end-2));
path = M(end).replace(["R", "L"], [" R ", " L "]).split();
gridMap = dictionary();

for y = 1:size(gridChar,1)
    for x = 1:size(gridChar,2)
        if gridChar(y,x) > ' '
            gridMap(complex(x,y)) = gridChar(y,x);
        end
    end
end
toc

%% Calculate result for both parts
part1 = traverseGrid(gridMap,path,false)
toc

part2 = traverseGrid(gridMap,path,true)
toc

%% Traversal function
function finalPassword = traverseGrid(G,P,part2)
position = G.keys;
position = position(1);
direction = 1;

for path = P'
    if path == 'R' % turn right
        direction = direction * 1j;
    elseif path == 'L' % turn left
        direction = direction * -1j;
    else % move
        for step = 1:str2double(path)
            newPosition = position + direction;
            if isKey(G,newPosition) % if other than ' '
                if G(newPosition) == '.' % do nothing when '#'
                    position = newPosition; % move when '.'
                end
            else % warp
                if part2
                    [newPosition, newDirection] = warp(position,direction);

                    if G(newPosition) == '.' % do nothing when '#'
                        position = newPosition; % move when '.'
                        direction = newDirection; % rotate when '.'
                    end
                else
                    newPosition = position;

                    while isKey(G,newPosition - direction) % while able to
                        newPosition = newPosition - direction; % move in reverse
                    end

                    if G(newPosition) == '.' % do nothing when '#'
                        position = newPosition; % move when '.;
                    end
                end
            end
        end
    end
end

finalPassword = 1000*imag(position) + 4*real(position) + find([1 1j -1 -1j]==direction)-1;
end

%% Warp function
function [Z,R] = warp(Z,R)

region = ceil(Z/50);
modR = mod(real(Z)-1,50);
modI = mod(imag(Z)-1,50);

region = find(region==[2+1j, 3+1j, 2+2j, 1+3j, 2+3j, 1+4j]);

switch true
    case region == 1 && R == -1j
        Z = 1 + (151 + modR)*1j;
        R = 1;
    case region == 6 && R == -1
        Z = 51 + modI + 1j;
        R = +1j;

    case region == 1 && R == -1
        Z = 1 + (150 - modI)*1j;
        R = +1;
    case region == 4 && R == -1
        Z = 51 + (50 - modI)*1j;
        R = +1;

    case region == 3 && R == -1
        Z = 1 +  modI + 101j;
        R = +1j;
    case region == 4 && R == -1j
        Z = 51 + (51+modR)*1j;
        R = +1;

    case region == 2 && R == -1j
        Z = 1 + modR + 200j;
        R = -1j;
    case region == 6 && R == 1j
        Z = 101 + modR + 1j;
        R = +1j;

    case region == 2 && R == 1
        Z = 100 + (150 - modI)*1j;
        R = -1;
    case region == 5 && R == 1
        Z = 150 + (50 - modI)*1j;
        R = -1;

    case region == 2 && R == 1j
        Z = 100 + (51 + modR)*1j;
        R = -1;
    case region == 3 && R == 1
        Z = 101 + modI + 50j;
        R = -1j;

    case region == 5 && R == 1j
        Z = 50 + (151 + modR)*1j;
        R = -1;
    case region == 6 && R == 1
        Z = 51 + modI + 150j;
        R = -1j;
end
end