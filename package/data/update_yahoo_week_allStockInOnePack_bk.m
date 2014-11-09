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

function update_yahoo_week(market, SS_CODE, SS_SHARE_ABB, ...
    SS_COMPANY, SS_INDUSTRY_CODE, SS_FIELD, SS_ADDRESS)

fprintf('\n     Week data checking %s %d ... ...', market, length(SS_CODE));

data_name = [pwd '/db/' market '_HIS_WEEK'];
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
    code = SS_CODE(i);
    % Update
    if ~isempty(HIS) && ~isempty(find([HIS{:, 1}] == code, 1))
        % FInd date to download from
        index = find([HIS{:, 1}] == code);
        laterest_date = HIS{index, 7}{size([HIS{index, 7}], 1)};
        if weekday(laterest_date) == 1
            next_monday = datenum(laterest_date) + 1;
        else
            next_monday = datenum(laterest_date) + (9 - weekday(laterest_date));
        end
        
        if next_monday >= datenum(date)
            LATEAST_HIS = HIS;
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
        hist = get_hist_stock_data1([num2str(code) '.' market], update_from_date, 'w');
    catch
        fprintf('x');
        continue;
    end

    if update_flag == true
        HIS{index, 7}  = [HIS{index, 7}; hist];
        fprintf('^');
        %fprintf('Upgrading week stock data: %d of %d ... ...\n', i, length(SS_CODE));
    else
        DATA = {code, SS_SHARE_ABB(i), SS_COMPANY(i), SS_FIELD(i), ...
            SS_INDUSTRY_CODE(i), SS_ADDRESS(i), hist};
        HIS = [HIS; DATA];
        fprintf('-');
        %fprintf('Downloading week stock data: %d of %d ... ...\n', i, length(SS_CODE));
    end
end

if ~isempty(HIS)
    save(data_name, 'HIS');
end

fprintf('\n     Week data checking %s end !!!\n', market);
