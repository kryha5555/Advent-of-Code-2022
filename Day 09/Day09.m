clear
clc

M = importdata('input.txt');
direction = cell2mat(M.textdata);
steps = M.data;

%% Calculate result for both parts
tic
rope = zeros(10,1);
seen = containers.Map("0",0);
seen2 = containers.Map("0",0);
dirs = containers.Map({'R', 'U', 'L', 'D'},{1, 1j, -1, -1j});

for x = 1:length(steps)
    for y = 1:steps(x)
        rope(1) = rope(1) + dirs(direction(x)); % move head

        for z = 2:10 % for each knot other than head
            dst = rope(z-1) - rope(z); % calculate distance between previous
            if abs(dst) >= 2 % >= 2 means not connected
                rope(z) = rope(z) + complex(sign(real(dst)), sign(imag(dst)));
            end
        end

        seen(string(rope(2))) = 1;
        seen2(string(rope(10))) = 1;
    end
end

part = length(seen.keys)
toc
part2 = length(seen2.keys)
toc