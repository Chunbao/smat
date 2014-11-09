%

function api_print_process(printIndex, total)


if mod(printIndex, 10) == 1
    if mod(printIndex, 100) == 1
        fprintf('\n%4d/%4d ', printIndex, total);
    else
        fprintf(' ');
    end
end