function [exportLidarDataResult] = exportLidarData(measureID, URL_output)
%EXPORTLIDARDATA Summary of this function goes here
%   Detailed explanation goes here

    run('config_file.m');
    disp(['User want to export LIDAR data for ', measureID]);

    currentFolder = fileparts(mfilename('fullpath'));  
    currentFolder = fileparts(currentFolder); % move to parent level (out of tools)
    
    lidarFolder = fullfile(currentFolder, CONFIG_LIDAR_folder, measureID);

    files = dir(fullfile(lidarFolder, '*.nc')); 
    
    if ~isempty(files)
    
        for k = 1:length(files)
            copyfile( fullfile(files(k).folder, files(k).name), URL_output);
        end
    end



    exportLidarDataResult =1;
end

