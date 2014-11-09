
function update_yahoo_dividends(market, SS_CODE)
% todo : need update 
%        stop it from updating everytime

fprintf('\n     Individents data checking %s %d ... ...', market, length(SS_CODE));
data_name = [pwd '/db/' market '_HIS_DIVIDENDS'];

HIS = {};

%for i = 1:3
for i = 1:length(SS_CODE)
    code_string = SS_CODE(i, :);
    update_from_date = '1990-12-19';
    api_print_process(i, length(SS_CODE));
    
    % Load
    try
        %hist = get_hist_stock_data1([num2str(code_string) '.ss'], update_from_date, 'm');
        stock_symbol = code_string;
        
        % Define starting year (the further back in time, the longer it takes to download)
        [start_year, start_month, start_day, dummy, dummy] = datevec(update_from_date);

        % Get current date
        [this_year, this_month, this_day, dummy, dummy] = datevec(date);

        % Build URL string
        url_string = 'http://ichart.yahoo.com/table.csv?';
        url_string = strcat(url_string, 's=', stock_symbol);
        url_string = strcat(url_string, '&d=', num2str(this_month -1));
        url_string = strcat(url_string, '&e=', num2str(this_day));
        url_string = strcat(url_string, '&f=', num2str(this_year));
        url_string = strcat(url_string, '&g=', 'v');
        url_string = strcat(url_string, '&a=', num2str(start_month - 1));
        url_string = strcat(url_string, '&b=', num2str(start_day));
        url_string = strcat(url_string, '&c=', num2str(start_year));
        url_string = strcat(url_string, '&ignore.csv');

        % Open a connection to the URL and retrieve data into a buffer
        buffer = java.io.BufferedReader(...
                 java.io.InputStreamReader(...
                 openStream(...
                 java.net.URL(url_string))));

        % Read the first line (a header) and discard
        dummy = readLine(buffer);

        % Read all remaining lines in buffer
        ptr = 1;
        hist = {};
        while 1
            % Read line
            buff_line = char(readLine(buffer)); 

            % Break if this is the end
            if length(buff_line)<3, break; end

            % Find comma delimiter locations
            commas = find(buff_line== ',');

            % Extract high, low, open, close, etc. from string
            DATEvar   = buff_line(1:commas(1)-1);
            INDIVENDS = str2num( buff_line(commas(1)+1:end) );

            hist = [hist; {DATEvar INDIVENDS}];
            ptr = ptr + 1;
        end
        hist = flipud(hist);        
        
    catch
        fprintf('*');
        continue;
    end

    % Update data
    DATA = {code_string, hist};
    HIS = [HIS; DATA];
    fprintf('-');

end

if ~isempty(HIS)
    save(data_name, 'HIS');
end

fprintf('\n     Individents data checking %s end !!!\n', market);