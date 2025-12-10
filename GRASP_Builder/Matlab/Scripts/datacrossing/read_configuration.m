% function read_configuration

%This script read the new CIMEL at 7 λ and Lidar SCC data and calls the WriteFiles_preGARRLiC_D1_L.m function.

% --- Step 1: Read config file ---
configFile = 'config_preview.txt';
configData = readlines(configFile);

% Initialize default values


selected_measure_ID = '';
fichero2 = '';
fichero3 = '';
sendData='false';


% Parse each line
for i = 1:length(configData)
    line = strtrim(configData(i));
    if startsWith(line, 'selected_measure_ID')
        selected_measure_ID = (extractAfter(line, '='));
    elseif startsWith(line, 'is_D1_L_checked')
        is_D1_L_checked = (extractAfter(line, '='));
    elseif startsWith(line, 'is_D1P_L_checked')
        is_D1P_L_checked = (extractAfter(line, '='));
    elseif startsWith(line, 'is_D1_L_VD_checked')
        is_D1_L_VD_checked = (extractAfter(line, '='));
    elseif startsWith(line, 'is_D1P_L_VD_checked')
        is_D1P_L_VD_checked = (extractAfter(line, '='));
    elseif startsWith(line, 'preview')
        preview = (extractAfter(line, '='));
    elseif startsWith(line, 'sendData')
        sendData = (extractAfter(line, '='));
    elseif startsWith(line, 'heightLimitMin')
        hMin = str2double(extractAfter(line, '='));
    elseif startsWith(line, 'heightLimitMax')
        hMax = str2double(extractAfter(line, '='));
    elseif startsWith(line, 'output_dir_sdat')
        output_dir_sdat = (extractAfter(line, '='));
    elseif startsWith(line, 'plot_ELPP')
        plot_ELPP = (extractAfter(line, '='));
    elseif startsWith(line, 'Folder_AERONET')
        Folder_AERONET = (extractAfter(line, '='));
    elseif startsWith(line, 'Folder_LIDAR')
        Folder_LIDAR = (extractAfter(line, '='))
    end
end
%%
% end