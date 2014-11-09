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

function update_yahoo_month(market, SS_CODE)

fprintf('\n     Month data checking %s %d ... ...', market, length(SS_CODE));

data_name = [pwd '/db/' market '_HIS_MONTH'];
try
    load(data_name);
    class(HIS);
    % ALways update, this could be comment out after testing
    %HIS = {};
catch
    HIS = {};
end

%for i = 1:3
for i = 1:length(SS_CODE)
    api_print_process(i, length(SS_CODE));
    code_string = SS_CODE(i, :);
    % Update
    if ~isempty(HIS) && ~isempty(strmatch(code_string, HIS(:, 1)))
        % FInd date to download from
        index = strmatch(code_string, HIS(:, 1));
        if size(index) > 1
            errRecord = MException(' *** No stock code, terminating ... \n');
            throw(errRecord); 
        end
        laterest_date = HIS{index, 2}{size([HIS{index, 2}], 1)};
        next_month_1st = api_next_month_1st(laterest_date);
        
        if datenum(next_month_1st) >= datenum(date)
            fprintf('o');
            continue;
        else
            % update
            update_from_date = next_month_1st;
            update_flag = true;
        end
    % Download. complete new or new release stock
    else
        update_from_date = '1990-12-19'; % Shanghai stock first open date
        update_flag = false;
    end

    % Load
    try
        hist = get_hist_stock_data1(code_string, update_from_date, 'm');
    catch
        fprintf('x');
        continue;
    end

    if update_flag == true
        HIS{index, 2}  = [HIS{index, 2}; hist];
        fprintf('^');
        %fprintf('Upgrading week stock data: %d of %d ... ...\n', i, length(SS_CODE));
    else
        DATA = {code_string, hist};
        HIS = [HIS; DATA];
        fprintf('-');
        %fprintf('Downloading week stock data: %d of %d ... ...\n', i, length(SS_CODE));
    end
end

if ~isempty(HIS)
    save(data_name, 'HIS');
end

fprintf('\n     Month data checking %s end !!!\n', market);
