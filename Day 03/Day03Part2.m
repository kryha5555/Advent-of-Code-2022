clear
clc

M = readmatrix('input.txt','OutputType','string');

%% Calculate result for part 2
tic
part2 = 0;
i = 1;

while(i < length(M))
    temp = char(M(i,1));
    
    commonChar = intersect(intersect(char(M(i,1)), char(M(i+1,1))), char(M(i+2,1)));
    
    if lower(commonChar) == commonChar
        part2 = part2 + double(commonChar) - 96;
    else
        part2 = part2 + double(commonChar) - 38;
    end
    
    i = i + 3;
end

part2
toc