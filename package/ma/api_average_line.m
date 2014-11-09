function [ out_date_series, average] = api_average_line( market, code, days )
%Function that calculates MA5, typically MA5 MA10 MA20 MA30 MA60
%   @
%
%   @pre  size(HIS{1, 2}, 1) > days

try
    load([pwd '/db/' market '_DAY/HIS_' code '.mat'])
catch
    out_date_series = {};
    average = {};
    return;
end

if size(HIS{1, 2}, 1) < days + 1
    errRecord = MException(' *** Stock data too short, terminating ... \n');
    throw(errRecord);
end
    
src_date_series = HIS{1, 2}(:, 1);
src_close = [HIS{1, 2}{:, 5}];

out_date_series = src_date_series( days : length(src_date_series) );
average = zeros(1, length(src_date_series) + 1 - days);

for i = 1 : (length(src_date_series) + 1 - days)
    average(i) = sum( src_close(i : (i + days - 1)) ) / days;
end

clear('HIS');

end

