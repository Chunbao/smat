%% Set parameter
clear;
UPDATE_DATA = false;

%% 1 - prepare

try
    load('SS');
    % load([pwd '/db/ss_WEEK/HIS_600000.ss.mat'])
    class(SS_CODE);
    load('SZ');
    class(SZ_CODE);
catch
    errRecord = MException(' *** No stock code, terminating ... \n');
    throw(errRecord);
end

    update_yahoo_day('ss', strcat(num2str(SS_CODE(:)), '.ss'));    
    update_yahoo_day('sz', strcat(SZ_CODE(:, :), '.sz'));

if UPDATE_DATA    
    update_yahoo_week('ss', strcat(num2str(SS_CODE(:)), '.ss'));
    update_yahoo_month('ss', strcat(num2str(SS_CODE(:)), '.ss'));
    update_yahoo_dividends('ss', strcat(num2str(SS_CODE(:)), '.ss'));
    
    update_yahoo_week('sz', strcat(SZ_CODE(:, :), '.sz'));
    update_yahoo_month('sz', strcat(SZ_CODE(:, :), '.sz'));
    update_yahoo_dividends('sz', strcat(SZ_CODE(:, :), '.sz'));
end
%% 2 - basic api calculate

%During a number of latest @days, ratio de/increase a specific @value
if true
    [ss_large_symbols] = ...
        large_trade('ss', strcat(num2str(SS_CODE(:)), '.ss'), 3, 0.03);
    [ss_large_symbols ss_large_ratios] = ...
        large_trade('ss', ss_large_symbols, 30, -0.2);

    [sz_large_symbols] = ...
        large_trade('sz', strcat(SZ_CODE(:, :), '.sz'), 3, 0.03);
    [sz_large_symbols sz_large_ratios] = ...
        large_trade('sz', sz_large_symbols, 30, -0.2);
end

if true
    [ss_trend_symbols ss_trend_ratios] = consective_trend_days(...
        'ss', strcat(num2str(SS_CODE(:)), '.ss'), 3, 0.05);
    
    [sz_trend_symbols sz_trend_ratios] = consective_trend_days(...
        'sz', strcat(SZ_CODE(:, :), '.sz'), 3, 0.05);
end
%[code_series] = api_arrived_ratio(obj_ratio, days);


 %% 3 - object optimize
%重点研究趋势线、流量与涨跌之间关系

% 10 day line cross 30 day line
% out_data_series = cross_point(days_data_series, days_data_series, up_or_down);

% Trend capturing, peak and vally value are bigger correspondantly than previous set


%% 4 - gui analysis

%% 5 - real time data

%% 6 - graph
report ('report_model', ...
    ['-o/Users/andrew/SkyDrive/report/' datestr(now, 'yyyy-mm-dd') '-.html']);
