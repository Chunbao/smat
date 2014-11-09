% Script to Retrieve web contents
%
% @para url, web address
% @para print, is bool, print out string on console
%
% @ret buffer, return a buffer

function [buffer] = getURL(url, print)

try
    
buffer = ...
java.io.BufferedReader(...
    java.io.InputStreamReader(...
    openStream(...
    java.net.URL(url))));

if print
    fprintf('------------------------------------------------------\n');
    while 1
        % Read line
        buff_line = readLine(buffer); 
        if buff_line ~= null
            fprintf('%s\n', char(buff_line));
        else
            break
        end
        % Break if this is the end
%         if length(buff_line) < 1,
%             break;
%         end
    
        % Find comma delimiter locations
    end
    fprintf('------------------------------------------------------\n');
    
end

catch
   buffer = {}; 
end