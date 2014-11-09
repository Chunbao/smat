function [ out_date_series, out_data ] = ...
    api_specific_date_period( date_series, value_series, specific_date, radius )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

index = find(datenum(date_series) >= datenum(specific_date), 1);

if index - radius < 1
    index_period_start = 1;
else
    index_period_start = index - radius;
end

if index + radius > length(date_series)
    index_period_end = length(date_series);
else
    index_period_end = index + radius;
end

out_date_series = date_series(index_period_start : index_period_end);
out_data = value_series(index_period_start : index_period_end);

end

