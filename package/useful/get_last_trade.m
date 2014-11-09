% Get Yahoo Last Trade 
% LuminousLogic.com

% The following script retrieves the "last trade" price for a given
% stock ticker symbol

% ex: last_trade = get_last_trade('AAPL');

function last_trade = get_last_trade(stock_symbol)

stock_symbol = upper(stock_symbol);

% Open connection to Yahoo! Finance statistics page
fprintf(1,'Retrieving Yahoo quote (last trade) for %s...', stock_symbol);
url_name = strcat('http://finance.yahoo.com/q?s=',  stock_symbol);
url     = java.net.URL(url_name);       % Construct a URL object
is      = openStream(url);              % Open a connection to the URL
isr     = java.io.InputStreamReader(is);
br      = java.io.BufferedReader(isr);

% Cycle through the source code until we find Last Trade...
while 1
    line_buff = char(readLine(br));
    ptr       = strfind(line_buff, 'Last Trade');
    
    % ...And break when we find it
    if length(ptr) > 0,break; end
    
    % Handle the case where either data not available or no trailing PE
    bad_ticker = strfind(line_buff, 'is not a valid');
    if length(bad_ticker) > 0, 
        fprintf(1,'\n%s is not a valid ticker symbol according to Yahoo.\n',stock_symbol);
        last_trade = NaN;
        return; 
    end
end

% Just to make it easier, strip off all the preceeding stuff we don't want
line_buff   = line_buff(ptr:end);

% Extract the last trade value
ptr_gt      = strfind(line_buff,'>');
ptr_lt      = strfind(line_buff,'<');
last_trade  = str2num(line_buff(ptr_gt(4)+1:ptr_lt(5)-1));
if length(last_trade) == 0
    fprintf(1,'N/A\n');
else
    fprintf(1,' = %3.2f\n', last_trade);
end