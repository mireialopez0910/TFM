% function read_configuration

%This script read the new CIMEL at 7 λ and Lidar SCC data and calls the WriteFiles_preGARRLiC_D1_L.m function.

% --- Step 1: Read config file ---
configData = readlines(configFile);

% Initialize default values


selected_measure_ID = '';
fichero2 = '';
fichero3 = '';
sendData='false';
CONFIG_output = '';

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
        Folder_LIDAR = (extractAfter(line, '='));
    elseif startsWith(line, 'selected_measurement_file_to_show')
        selected_measurement_file_to_show = (extractAfter(line, '='));
    elseif startsWith(line, 'path_to_figure_data')
        path_to_figure_data = (extractAfter(line, '='));
    elseif startsWith(line, 'output_dir')
        CONFIG_output = (extractAfter(line, '='));
    end
end
%% 
% end
