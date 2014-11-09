function [symbols ret_ratios] = consective_trend_days(...
    market, SS_CODE, consective_days, sum_ratio)
%For last @consective days, stock price increased everyday.
% and the total ratio for those days has reached or even bigger
% than @sum_ratio.
%
% On the contray, if sum_ratio is negtive, the stock price need
% to be decreased everyday. and the @sum_ratio should smaller
% than the total decreased ratio.

symbols = [];
ret_ratios = [];

fprintf('\n     consective_trend_days %s %d ... ...', market, length(SS_CODE));

%for i = 1:3
for i = 1:length(SS_CODE)
    
    api_print_process(i, length(SS_CODE));
    code_string = SS_CODE(i, :);
    data_name = [pwd '/db/' market '_DAY/HIS_' code_string '.mat'];
    
    try
        load(data_name);
        class(HIS);
    catch
        fprintf('?');
        continue;
    end

    % Find
    if ~isempty(HIS)
        
        if size(HIS{2}, 1) - consective_days <= 0
            fprintf('o');
            continue;
        end
        
        flag = true;
        if sum_ratio > 0
            for j = 1 : consective_days
                if HIS{2}{size(HIS{2}, 1) - j + 1, 5} <=  ...
                    HIS{2}{size(HIS{2}, 1) - j, 5}
                    flag = false;
                    break
                end
            end
            if flag
                now = HIS{2}{size(HIS{2}), 5};
                days_before = HIS{2}{size(HIS{2}, 1) - consective_days, 5};
                code_ratio = (now - days_before) / days_before;
                if  code_ratio > sum_ratio
                    symbols = [symbols; SS_CODE(i, :)];
                    ret_ratios = [ret_ratios; code_ratio];
                    fprintf('Y');
                end
            else
                fprintf('-');
                continue; 
            end
        else
            for j = 1 : consective_days
                if HIS{2}{size(HIS{2}, 1) - j + 1, 5} >=  ...
                    HIS{2}{size(HIS{2}, 1) - j, 5}
                    flag = false;
                    break
                end
            end
            if flag
                now = HIS{2}{size(HIS{2}), 5};
                days_before = HIS{2}{size(HIS{2}, 1) - consective_days, 5};
                code_ratio = (now - days_before) / days_before;
                if code_ratio < sum_ratio
                    symbols = [symbols; SS_CODE(i, :)];
                    ret_ratios = [ret_ratios; code_ratio];
                    fprintf('Y');
                end
            else
                fprintf('-');
                continue; 
            end
        end
        
    end
    
end

fprintf('\n     consective_trend_days checking end !!!\n');

end

