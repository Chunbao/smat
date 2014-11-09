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

fprintf('\n==========================\n');
% time span that used to compare values
span_length = 5; 
for i = 1 : length(SS_CODE)
    api_print_process(i, length(SS_CODE));
    code = strcat(num2str(SS_CODE(i)), '.ss');
    % out_data_series = average_line(src_data_series, days);
    [ out_data_series_10, increase_ratio_10] = api_average_line('ss', code, 10);
    if isempty(out_data_series_10)
        fprintf('F');
        continue;
    end
    [ out_data_series, increase_ratio] = api_average_line('ss', code, 5);
    if isempty(out_data_series)
        fprintf('F');
        continue;
    end
    
    len = length(increase_ratio_10);
    if len <= span_length
        span = 1 : len;
    else
        span = (len - span_length + 1):len;
    end
    
    len1 = length(increase_ratio);
    if len1 <= span_length
        span1 = 1 : len1;
    else
        span1 = (len1 - span_length + 1) : len1;
    end
    
    if increase_ratio_10(span) < increase_ratio(span1)
        fprintf('-%s-', code);
    else
        fprintf('*');
    end

end
fprintf('\n==========================\n');

% [ out_data_series_10s, increase_ratio_10s] = api_specific_date_period( ...
%     out_data_series_10, increase_ratio_10, '2012-9-1', 30);
% [ out_data_series_s, increase_ratio_s] = api_specific_date_period( ...
%     out_data_series, increase_ratio, '2012-9-1', 30);
% 
% hold all
% plot(datenum(out_data_series_10s), increase_ratio_10s);
% plot(datenum(out_data_series_s), increase_ratio_s, 'r');
% %a = datenum(HIS{1, 2}(:, 1));
% %set(gca,'XTick', a(1):(length(a)/4):a(length(a)));
% datetick('x','yy/mm/dd','keepticks');
% grid on;