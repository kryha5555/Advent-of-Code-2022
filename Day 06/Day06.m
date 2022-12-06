clear
clc

M = importdata('input.txt');
M = M{1};

%% Calculate result for part 1
tic
part1 = getMarkerPos(M,4)
toc

%% Calculate result for part 2
part2 = getMarkerPos(M,14)
toc

%% Helper function
function x = getMarkerPos(B,L)
    for x = L:length(B)
        slice = B(x-L+1:x) ;
        if length(unique(slice)) == L
            return
        end
    end
end