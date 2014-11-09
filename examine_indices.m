% Examines recent price and volume activity of 3 major
%    indices to help in forecasting market direction.

% LuminousLogic.com


% Initialize Workspace
clear all;
close all;


% User-defined parameters
% THE VALUES BELOW ARE JUST DEFAULT PLACEHOLDERS AND NOT NECESSARILY OPTIMAL!
%    (1) List tickers of indices we will examine
indices_list = {'^DJI' '^IXIC' '^GSPC'}; % Dow, NASDAQ, S&P 500
%    (2) Set observation window size
obsv_win     = 20; % Examining last 20 trading days
%    (3) Stall range - if the change in price is between these two values,
%        we'll throw a 'possible stall' flag
stall_high = 1.001; % If price movement is 0.1% higher or lower than previous
stall_low  = 0.999; % day, we'll call that a possible stall 


% Retrive data from Yahoo! Finance and plot the results
for index=1:length(indices_list)

    % Retrieve historical index data
    fprintf(1,'Retrieving %s...', indices_list{index});
    [hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol] = get_hist_stock_data(indices_list{index});
    fprintf(1,'done!\n');
    
    % Go ahead and compute average close and volume here
    low_ave_50d   = zeros(length(hist_low),1);
    low_ave_200d  = zeros(length(hist_low),1);
    vol_ave_50d   = zeros(length(hist_vol  ),1);
    vol_ave_200d  = zeros(length(hist_vol  ),1);
    for i=51:length(hist_close)
        low_ave_50d(i) = mean(hist_low(i-50:i-1));
        vol_ave_50d(i) = mean(hist_vol(i-50:i-1));
    end
    for i=201:length(hist_close)
        low_ave_200d(i) = mean(hist_low(i-200:i-1));
        vol_ave_200d(i) = mean(hist_vol(i-200:i-1));
    end
    
    % Extract only the last obsv_win+1 days worth of data
    hist_date    = {hist_date{end-obsv_win:end}};
    hist_high    = hist_high   (end-obsv_win:end);
    hist_low     = hist_low    (end-obsv_win:end);
    hist_open    = hist_open   (end-obsv_win:end);
    hist_close   = hist_close  (end-obsv_win:end);
    hist_vol     = hist_vol    (end-obsv_win:end);
    low_ave_50d  = low_ave_50d (end-obsv_win:end);
    low_ave_200d = low_ave_200d(end-obsv_win:end);
    vol_ave_50d  = vol_ave_50d (end-obsv_win:end);
    vol_ave_200d = vol_ave_200d(end-obsv_win:end);
    
    % Print some stats to screen
    %   
    acc_days   = find((hist_close(2:end) >= (hist_close(1:end-1)*stall_high)) & (hist_vol(2:end) > hist_vol(1:end-1)));
    dist_days  = find((hist_close(2:end) <= (hist_close(1:end-1)*stall_low )) & (hist_vol(2:end) > hist_vol(1:end-1)));
    stall_days = find(((hist_close(2:end)./ hist_close(1:end-1))<stall_high) & ...
                      ((hist_close(2:end)./ hist_close(1:end-1))>stall_low ) & ...
                       (hist_vol(2:end) > vol_ave_50d(2:end)));
    fprintf(1,'In the last %d trading days, this index has had:\n',obsv_win);
    fprintf(1,'   %2d days of possible accumulation (closed higher & on larger volume than previous day)\n',length( acc_days));
    fprintf(1,'   %2d days of possible distribution (closed lower  & on larger volume than previous day)\n',length(dist_days));
    fprintf(1,'   %2d days of possible stalling     (closed roughly the same as previous day but on larger than normal volume)\n',length(stall_days));

    % Plot Price
    figure;
    subplot(2,1,1);
    for i=2:obsv_win+1
        if hist_close(i-1)<hist_close(i)
            plot(i-1,     hist_open(i), 'ko');  hold on;
            plot(i-1,     hist_close(i),'kx');
            plot([i-1 i-1],[hist_low(i) hist_high(i)],'k');
        else
            plot(i-1,     hist_open(i), 'ro');  hold on;
            plot(i-1,     hist_close(i),'rx');
            plot([i-1 i-1],[hist_low(i) hist_high(i)],'r'); hold on;
        end
    end
    plot(low_ave_50d(2:end), 'r');
    plot(low_ave_200d(2:end),'k');
    for i=1:length(acc_days)
        text(acc_days(i),low_ave_50d(acc_days(i)),'A')
    end
    for i=1:length(dist_days)
        text(dist_days(i),low_ave_50d(dist_days(i)),'D')
    end
    for i=1:length(stall_days)
        text(stall_days(i),low_ave_50d(stall_days(i)),'S')
    end
   
    grid on;
    xlabel('Day');
    ylabel('Price');
    switch indices_list{index}
        case '^DJI'
            title_str = 'Dow';
        case '^IXIC'
            title_str = 'NASDAQ';
        case '^GSPC'
            title_str = 'S&P 500';
        otherwise
            title_str = indices_list{index};
    end
    title([title_str ': ' num2str(length(acc_days)) ' possible accumulation (A) days, ' num2str(length(dist_days)) ' possible distribution (D) days, ' num2str(length(stall_days)) ' possible stall (S) days']);
    axis tight;

    % Plot volume
    subplot(2,1,2);
    plot(vol_ave_50d(2:end)/1e6,'r'); hold on;
    plot(vol_ave_200d(2:end)/1e6,'k');
    stem(hist_vol(2:end)/1e6);
    xlabel('Day')
    ylabel('Volume [Millions]')
    axis tight;
    grid on;
    legend('50-day moving average', '200-day moving average', 3)
    pause(0.1);
end