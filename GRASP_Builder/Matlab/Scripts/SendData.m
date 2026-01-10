% cfgSelected = 'D1_L: Photometer + lidar' 
GARRLiC_file_name = '';
errorVolumePolarization = false;
fid = fopen('scripts_output.txt','a');
if strcmpi(strtrim(is_D1P_L_VD_checked), "true")
    [GARRLiC_file_name, errorVolumePolarization] = sendData_D1P_L_VD(selected_measure_ID, hMin, hMax, 0, 0, CONFIG_output);
    fprintf(fid, 'selected_config = D1P_L_VD\n');
end
if strcmpi(strtrim(is_D1P_L_checked), "true")
    GARRLiC_file_name = sendData_D1P_L(selected_measure_ID, hMin, hMax, 0, 0, CONFIG_output);
    fprintf(fid, 'selected_config = D1P_L\n');
end
if strcmpi(strtrim(is_D1_L_VD_checked), "true")
    [GARRLiC_file_name, errorVolumePolarization] = sendData_D1_L_VD(selected_measure_ID, hMin, hMax, 0, 0, CONFIG_output);
    fprintf(fid, 'selected_config = D1_L_VD\n');
end
if strcmpi(strtrim(is_D1_L_checked), "true")
    GARRLiC_file_name = sendData_D1_L(selected_measure_ID, hMin, hMax, 0, 0, CONFIG_output);
    fprintf(fid, 'selected_config = D1_L\n');
end

if ~isempty(GARRLiC_file_name)
    logMessage( ['GARRLiC: output file ', GARRLiC_file_name, ' written correctly']);
    fprintf(fid, 'GARRLiC_file_name = %s\n', GARRLiC_file_name);
else
    logMessage('GARRLiC: error writing the output file');
    if(errorVolumePolarization)
        logMessage('----- Affected fields: VD355, VD532, RangeVD355, RangeVD532 || Please check LIDAR Volume Polarization avaliability in ''008'' files || ERROR: Volume Polarization missing data');
    end
end

fclose(fid);