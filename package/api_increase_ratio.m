function [ out_date_series, increase_ratio] = api_increase_ratio( ...
market, type, code, latest_records)

%Return date series and their correspondant day increase ratio
%  C = (B-A)/A * 100%
%  A : yesterday's close value
%  B : today's adj close value
%  C : today's increase ratio
%
% todo: need validation of input parameters
% latest_records >= 2

load([pwd '/db/' market '_' type '/HIS_' code '.mat'])

if size(HIS{1, 2}, 1) > latest_records + 1
    latest_date = (size(HIS{1, 2}, 1) - latest_records -1) : size(HIS{1, 2}, 1);
else
    latest_date = 1 : size(HIS{1, 2}, 1);
end
    
src_date_series = HIS{1, 2}(latest_date, 1);
src_close = [HIS{1, 2}{latest_date, 5}];
src_adj_close = [HIS{1, 2}{latest_date, 7}];

out_date_series = src_date_series(2:length(src_date_series));
increase_ratio = zeros(1, length(src_date_series) - 1);
for i = 1 : (length(src_date_series) - 1)
    increase_ratio(i) = (src_adj_close(i + 1) - src_close(i)) / src_close(i);
end

clear('HIS');
end

