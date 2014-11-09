function [symbols ret_ratios] = large_trade(market, SS_CODE, days, ratio)
%Last @days(3 to 5 days) the price has increased @ratio
% 
% ---------------------------------->now
%           days     day5    day3    day0   

symbols = [];
ret_ratios = [];

fprintf('\n     large_trade %s %d ... ...', market, length(SS_CODE));

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
        if size(HIS{2}, 1) - days <= 0
            fprintf('o');
            continue;
        end
        
        now = HIS{2}{size(HIS{2}), 5};
        days_before = HIS{2}{size(HIS{2}, 1) - days, 5};
        
        code_ratio = (now - days_before)/days_before;
        if ratio > 0
            if code_ratio > ratio
                symbols = [symbols; SS_CODE(i, :)];
                ret_ratios = [ret_ratios; code_ratio];
                fprintf('Y');
            else
                fprintf('-');
            end
        else
            if code_ratio < ratio
                symbols = [symbols; SS_CODE(i, :)];
                ret_ratios = [ret_ratios; code_ratio];
                fprintf('Y');
            else
                fprintf('-');
            end
        end
        
    end
    
end

fprintf('\n     large_trade checking end !!!\n');

end