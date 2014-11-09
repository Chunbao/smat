function next_month_1st = api_next_month_1st(src_date)

try
    datenum(src_date);
catch
    errRecord = MException('Verify:Date', ['Invalid date format:' src_date]);
    throw(errRecord);
end

[this_year, this_month, this_day, dummy, dummy] = datevec(src_date);

next_month_1st = [num2str(this_year) '-' num2str(this_month + 1) '-1'];