function update_yahoo_day(market, SS_CODE)
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

fprintf('\n     Day data checking %s %d ... ...', market, length(SS_CODE));

%for i = 1:3
for i = 1:length(SS_CODE)
    
    api_print_process(i, length(SS_CODE));
    code_string = SS_CODE(i, :);
    data_name = [pwd '/db/' market '_DAY/HIS_' code_string '.mat'];
    
    try
        load(data_name);
        class(HIS);
    catch
        HIS = {};
    end

    % Prepare
    if ~isempty(HIS)
        laterest_date = HIS{2}{size(HIS{2}, 1)};
        span = datenum(date) - datenum(laterest_date);
        if (( span < 2) ...
            || (span == 2 && weekday(laterest_date) == 6) ...
            || (span == 3 && weekday(laterest_date) == 6))
           
            % no update
            % LATEAST_HIS = HIS;
            %fprintf('    Skipped day stock data update, already laterest. \n');
            fprintf('o');
            continue;
        else
            % update
            update_from_date = datestr(datenum(laterest_date, ...
                'yyyy-mm-dd') + 1,'yyyy-mm-dd');
            update_flag = true;
        end
    else
        % download
        update_from_date = '1990-12-9';
        update_flag = false;
    end

    % Load
    try
        hist = get_hist_stock_data1(code_string, update_from_date, 'd');
    catch
        %fprintf(' *** ***  Data error: %d of %d *** ***\n', i, length(SS_CODE));
        fprintf('x');
        continue;
    end

    % Update data
    if update_flag == true
        HIS{2}  = [HIS{2}; hist];
        fprintf('^');
        %fprintf('Upgrading day stock data: %d of %d ... ...\n', i, length(SS_CODE));
    else
        HIS = {code_string, hist};
        %HIS = [HIS; DATA];
        %fprintf('Downloading day stock data: %d of %d ... ...\n', i, length(SS_CODE));
        fprintf('-');
    end
    
    if ~isempty(HIS)
        save(data_name, 'HIS');
    end
    
end

fprintf('\n     Day data checking end !!!\n');
%LATEAST_HIS = HIS;
