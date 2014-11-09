%%
fprintf('----------\n');

SS_CODE = 










if 0
%%

url_string = 'http://www.sse.com.cn/sseportal/cn/zqpz/gp.shtml';
% url_string = strcat(url_string, '/SSEQueryStockInfoAct?keyword=');
% url_string = strcat(url_string, '&reportName=BizCompStockInfoRpt');
% url_string = strcat(url_string, '&PRODUCTID=&PRODUCTJP=&PRODUCTNAME=&CURSOR=1');

% Open a connection to the URL and retrieve data into a buffer
buffer      = java.io.BufferedReader(...
              java.io.InputStreamReader(...
              openStream(...
              java.net.URL(url_string))));
getUrl(url_string, true);

%%

% Read the first line (a header) and discard
dummy   = readLine(buffer);


% Read all remaining lines in buffer
ptr = 1;
while 1
    % Read line
    buff_line = char(readLine(buffer)); 
    
    % Break if this is the end
    if length(buff_line)<3, break; end
    
    % Find comma delimiter locations
    commas    = find(buff_line== ',');
    
    % Extract high, low, open, close, etc. from string
    DATEvar   = buff_line(1:commas(1)-1);
    OPENvar   = str2num( buff_line(commas(1)+1:commas(2)-1) );
    HIGHvar   = str2num( buff_line(commas(2)+1:commas(3)-1) );
    LOWvar    = str2num( buff_line(commas(3)+1:commas(4)-1) );
    CLOSEvar  = str2num( buff_line(commas(4)+1:commas(5)-1) );
    VOLvar    = str2num( buff_line(commas(5)+1:commas(6)-1) );
    adj_close = str2num( buff_line(commas(6)+1:end) );

    %Adjust for dividends, splits, etc.
    DATEtemp{ptr,1} = DATEvar;
    OPENtemp(ptr,1) = OPENvar  * adj_close / CLOSEvar;
    HIGHtemp(ptr,1) = HIGHvar  * adj_close / CLOSEvar;
    LOWtemp (ptr,1) = LOWvar   * adj_close / CLOSEvar;
    CLOSEtemp(ptr,1)= CLOSEvar * adj_close / CLOSEvar;
    VOLtemp(ptr,1)  = VOLvar;

    ptr = ptr + 1;
end

end