clear
clc

M = readmatrix('input.txt','OutputType','string');

%% Calclate result for part 1
tic
part1 = 0;

for i = 1:length(M)
    mid = strlength(M(i))/2;
    temp = char(M(i,1));
    
    commonChar = intersect(temp(1,1:mid), temp(1,mid+1:end));
    
    if lower(commonChar) == commonChar
        part1 = part1 + double(commonChar) - 96 ;
    else
        part1 = part1 + double(commonChar) - 38;
    end
end

part1
toc