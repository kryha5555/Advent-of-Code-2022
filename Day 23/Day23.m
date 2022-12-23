clear
clc

M = char(readlines("input.txt"));

%% Prepare starting elfs
tic
currentElfs = dictionary();
for y = 1:size(M,1)
    for x = 1:size(M,2)
        if M(y,x) == '#'
            currentElfs(complex(x,y)) = 1;
        end
    end
end

proposals = [-1-1j -1j 1-1j; -1+1j 1j 1+1j; -1-1j -1 -1+1j; 1-1j 1 1+1j]; % NSWE
neighbours = [-1-1j -1j 1-1j -1 1 -1+1j +1j 1+1j];

%% Simulate elf movement
round = 1;
elfCount = numEntries(currentElfs);

while true
    currentElfKeys = keys(currentElfs);
    wantsToMoveTo = dictionary([],cell(0));

    % Calculate movement for each elf
    for elfIdx = 1:elfCount
        isMoving = 0;
        currElf = currentElfKeys(elfIdx);

        % If current elf has no neighbours
        if all(currElf + neighbours ~= currentElfKeys, "all")
            % Current elf wants to move to current position
            if isKey(wantsToMoveTo,currElf)
                % If key already existing, position to value
                tempPos = wantsToMoveTo(currElf);
                tempPos{1}(end+1) = currElf;
                wantsToMoveTo(currElf) = tempPos;
            else
                % If key not already existing, create key
                wantsToMoveTo(currElf) = {currElf};
            end
            % Go to next elf
            continue
        end

        % If current elf has neighbours, look for proposed directions
        for p = 1:size(proposals,1) % for each direction
            % If there is no elf in currently considered direction
            if ~sum(currElf+proposals(p,:)==currentElfKeys,'all')
                % Current elf wants to move into that direction
                tempElf = currElf + proposals(p,2);
                if isKey(wantsToMoveTo,tempElf)
                    tempPos = wantsToMoveTo(tempElf);
                    tempPos{1}(end+1) = currElf;
                    wantsToMoveTo(tempElf) = tempPos;
                else
                    wantsToMoveTo(tempElf) = {currElf};
                end

                % Mark elf as moving
                isMoving = 1;
                break
            end
        end

        % If elf has neighbours but was unable to move
        if isMoving == 0
            % Current elf wants to move to current position
            if isKey(wantsToMoveTo,currElf)
                tempPos = wantsToMoveTo(currElf);
                tempPos{1}(end+1) = currElf;
                wantsToMoveTo(currElf) = tempPos;
            else
                wantsToMoveTo(currElf) = {currElf};
            end
        end
    end

    % Save current elf positions for part 2 comparison
    oldElfs = currentElfs;
    currentElfs = dictionary([],[]);

    % Get movements from wantsToMoveTo: Destination -> Source
    movementSource = values(wantsToMoveTo);
    movementDestination = keys(wantsToMoveTo);

    % For each movement destination
    for destIdx = 1:length(movementDestination)
        % If only one elf wants to move to destination
        if length(movementSource{destIdx}) == 1
            % Let him move
            currentElfs(movementDestination(destIdx)) = 1;
        else
            % If more elfs wants to move to destination
            for elfIdx = 1:length(movementSource{destIdx})
                % Do not let them move
                currentElfs(movementSource{destIdx}(elfIdx)) = 1;
            end
        end
    end

    % Result for part 1
    if round == 10
        currentElfKeys = keys(currentElfs);

        % Get bounds in real axis
        minx = min(real(currentElfKeys));
        maxx = max(real(currentElfKeys));

        % Get bounds in imag axis
        miny = min(imag(currentElfKeys));
        maxy = max(imag(currentElfKeys));

        % Calculate result for part 1
        part1 = (maxx - minx + 1) * (maxy - miny + 1) - length(currentElfKeys)
        toc
    end

    % If no elf movement, get result for part 2
    if isequal(keys(oldElfs),keys(currentElfs))
        part2 = round
        toc
        return
    end

    % Increment round, move proposals
    round = round + 1;
    proposals = circshift(proposals,-1);
end