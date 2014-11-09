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

function [LATEAST_HIS] = update_from_yahoo1(HIS, SS_CODE, SS_SHARE_ABB, ...
    SS_COMPANY, SS_INDUSTRY_CODE, SS_FIELD, SS_ADDRESS)

code = SS_CODE;
if ~isempty(HIS)        
    laterest_date = HIS{7}{size(HIS{7}, 1)};
    laterest_date = datestr(datenum(laterest_date, ...
        'yyyy-mm-dd') + 1,'yyyy-mm-dd');
    update_flag = true;
else
    laterest_date = '2012-8-1';
    update_flag = false;
end

try
    hist = get_hist_stock_data1([num2str(code) '.ss'], laterest_date);
catch
    fprintf(' *** ***  Data error *** ***\n');
    return;
end


if update_flag == true
    HIS{7}  = [HIS{7}; hist];
    %fprintf('Upgrading stock data: %d of %d ... ...\n', i, length(SS_CODE));
else
    HIS = {code, SS_SHARE_ABB, SS_COMPANY, SS_FIELD, ...
        SS_INDUSTRY_CODE, SS_ADDRESS, hist};
    %fprintf('Downloading stock data: %d of %d ... ...\n', i, length(SS_CODE));
end

LATEAST_HIS = HIS;