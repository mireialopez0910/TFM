function logMessage(message)
    try
        % fid = fopen('myfile.txt', 'a');
        % fprintf(fid, '%s || %s\n', datestr(now),message);
        % fclose(fid);
        disp(message)
    catch
    end
end