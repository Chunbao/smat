% Script to upgrade data
%
% @Note: Default "starting data" is set here. If you want to start from a 
%       date earlier that this one, you should remove local data and
%       perform a fresh downloading.
%
%       For new stock or removed stock, user should add their correspondant
%       information in variables SS_***. New released stock is appended at
%       the back of vector. For removed stock, its data will be stored in 
%       local database.
% @todo: For removed stock, a flag could be saved somewhere.

function update_yahoo_week(market, SS_CODE)

fprintf('\n     Week data checking %s %d ... ...', market, length(SS_CODE));

%for i = 1:3
for i = 1:length(SS_CODE)    
    api_print_process(i, length(SS_CODE));
    code_string = SS_CODE(i, :);
    data_name = [pwd '/db/' market '_WEEK/HIS_' code_string '.mat'];

    try
        load(data_name);
        class(HIS);
        % ALways update, this could be comment out after testing
        %HIS = {};
    catch
        HIS = {};
    end
    
    % Update
    if ~isempty(HIS) % delete && ~isempty(find([HIS{:, 1}] == code_string, 1))
        laterest_date = HIS{2}{size(HIS{2}, 1)};
        if weekday(laterest_date) == 1
            next_monday = datenum(laterest_date) + 1;
        else
            next_monday = datenum(laterest_date) + (9 - weekday(laterest_date));
        end
        
        if next_monday >= datenum(date)
            fprintf('o');
            continue;
        else
            % update
            update_from_date = datestr(next_monday,'yyyy-mm-dd');
            update_flag = true;
        end
    % Download. complete new or new release stock
    else
        update_from_date = '1990-12-19'; % Shanghai stock first open date
        update_flag = false;
    end

    % Load
    try
        hist = get_hist_stock_data1(code_string, update_from_date, 'w');
    catch
        fprintf('x');
        continue;
    end

    if update_flag == true
        HIS{2}  = [HIS{2}; hist];
        fprintf('^');
        %fprintf('Upgrading week stock data: %d of %d ... ...\n', i, length(SS_CODE));
    else
        HIS = {code_string, hist};
        fprintf('-');
        %fprintf('Downloading week stock data: %d of %d ... ...\n', i, length(SS_CODE));
    end
    
    if ~isempty(HIS)
        save(data_name, 'HIS');
    end
end

fprintf('\n     Week data checking %s end !!!\n', market);