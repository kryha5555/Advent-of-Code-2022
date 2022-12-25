clear
clc

M = readlines('input.txt');

%% Calculate result for the only part
tic
part1 = 0;
for n = M'
    part1 = part1 + snafu2dec(char(n));
end

[part1 dec2snafu(part1)]
toc

%% SNAFU to decimal
function decimal = snafu2dec(SNAFU)
% Base case
decimal = 0;

if ~isempty(SNAFU)
    % Pop last character
    decimal = SNAFU(end);
    SNAFU = SNAFU(1:end-1);

    % Recursively call conversion function
    decimal = snafu2dec(SNAFU)*5 + find('=-012'==decimal)-3;
end
end


%% Decimal to SNAFU
function SNAFU = dec2snafu(decimal)
% Base case
charset = ['=-012'];
SNAFU = "";

if decimal
    % Get quotient and remainder
    Q = mod(decimal+2, 5);
    R = floor((decimal+2)./5);

    % Recursively call conversion function
    SNAFU = dec2snafu(R) + charset(Q+1);
end
end