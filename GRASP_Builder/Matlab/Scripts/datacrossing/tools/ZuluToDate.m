function StandardDate = ZuluToDate(inputdate)
    inputdate = strrep(inputdate, 'T', ' ');
    inputdate = strrep(inputdate, 'Z', '');
    StandardDate = datetime(inputdate, 'InputFormat', 'yyyy-MM-dd HH:mm:ss'); 
end