function foundFiles = read_NetCDF_(measureID, Folder_LIDAR)

    % try
        
        addpath('tools');

        run('config_file.m');
        currentFolder = fileparts(mfilename('fullpath'));  
        URL_LIDAR = Folder_LIDAR+measureID+'/';
    
        % Obtener la lista de archivos .nc en la subcarpeta
        files = dir(fullfile(URL_LIDAR, '*.nc')); 
        foundFiles = length(files);
    
        logMessage(['LIDAR Files found; ', num2str(length(files))]);

        % Inicializar estructuras para almacenar datos    
        clear dataStruct;
        dataStruct = struct([]);
        
        countEligibleFiles = 1;
      
        if ~isempty(files)
    
            for k = 1:numel(files)
                
                % Obtener el nombre del archivo
                fileName = files(k).name;
                fileInputPath = fullfile(URL_LIDAR, fileName);
             
                if (contains(fileInputPath, '_1064_') || contains(fileInputPath, '_0532_') || contains(fileInputPath, '_0354_') || contains(fileInputPath, '_0354_'))
                    
                    if(contains(fileInputPath, '_0532_'))
                        wavelength="0532";
                    end
                    if(contains(fileInputPath, '_1064_'))
                        wavelength="1064";
                    end
                    if(contains(fileInputPath, '_0354_') || contains(fileInputPath, '_0354_'))
                        wavelength="0355";
                    end
                    
                    % logMessage('Read ELPP altitude and range from file:')
                    % logMessage(fileInputPath)
                    % nclogMessage(fileInputPath)
                    dataStruct(countEligibleFiles).elpp_measurement_start_datetime = ZuluToDate( ncreadatt(fileInputPath,'/', 'measurement_start_datetime') );
                    dataStruct(countEligibleFiles).elpp_measurement_stop_datetime = ZuluToDate( ncreadatt(fileInputPath,'/', 'measurement_stop_datetime') );
                    dataStruct(countEligibleFiles).elpp_altitude = ncread(fileInputPath, 'altitude');
                    dataStruct(countEligibleFiles).range = ncread(fileInputPath, 'range');
                    
                    % wavelength = ncread(fileInputPath, 'wavelength');
                    dataStruct(countEligibleFiles).wavelength = wavelength;
                    polarization_channel_geometry = ncread(fileInputPath, 'polarization_channel_geometry');
                    range_corrected_signal = ncread(fileInputPath, 'range_corrected_signal');
                    
                    total_power_channel = range_corrected_signal(:, 1, 1);
                    cross_polarization_channel = NaN;
                    
                    %whos polarization_channel_geometry;
                    flag = polarization_channel_geometry(1); % Leer el flag
                       
                    % Determinar el tipo de canal basado en el flag
                    if flag == 1
                        % Canal 1: Total Power Channel
                        total_power_channel = (range_corrected_signal(:, 1, 1));
                        cross_polarization_channel = (range_corrected_signal(:, 1, 2));
                    elseif flag == 2
                        % Canal 2: Polarización Cruzada
                        total_power_channel =(range_corrected_signal(:, 1, 2));
                        cross_polarization_channel = (range_corrected_signal(:, 1, 1));
                    end  
                           
                    dataStruct(countEligibleFiles).cross_polarization_channel = cross_polarization_channel;
                    dataStruct(countEligibleFiles).total_power_channel = total_power_channel;
                    dataStruct(countEligibleFiles).range_corrected_signal = range_corrected_signal;
        
                    dataStruct(countEligibleFiles).fileName = fileName;
        
                    % Add attribute
                    dataStruct(countEligibleFiles).attr_color = "black";
        
                    if contains(fileName, '_1064_') 
                        dataStruct(countEligibleFiles).attr_color = "red";
                    end
        
                    if contains(fileName, '_0532_')
                        dataStruct(countEligibleFiles).attr_color = "green";
                    end
        
                    if contains(fileName, '_0354_') 
                        dataStruct(countEligibleFiles).attr_color = "blue";
                    end

                    folder = URL_LIDAR;
                    searchString = "b"+wavelength;

                    files_aux = dir(fullfile(folder, '**', '*.*'));
                    foundFile = '';

                    for i = 1:numel(files_aux)
                        if ~files_aux(i).isdir
                            filePath = fullfile(files_aux(i).folder, files_aux(i).name);
                            try
                                if contains(filePath, searchString)
                                    foundFile = filePath;
                                    break
                                end
                            catch
                            end
                        end
                    end

                    filePath = foundFile;
                    if(filePath~="")
                        elda_measurement_start_datetime = ncreadatt(filePath,'/', 'measurement_start_datetime');
                        elda_measurement_stop_datetime = ncreadatt(filePath,'/', 'measurement_stop_datetime');
            
                        % wavelength = ncread(filePath, 'wavelength')
                        elda_altitude = ncread(filePath, 'altitude');
                        input_file = ncreadatt(filePath,'/', 'input_file');
                        backscatter = ncread(filePath, 'backscatter');
                        error_backscatter = ncread(filePath, 'error_backscatter');
                        try extinction=ncread(filePath, 'extinction'); catch extinction = NaN; end
                        try error_extinction=ncread(filePath, 'error_extinction'); catch error_extinction = NaN; end
            
                        % Procesar campos en archivo tipo brc_008
                        try volumedepolarization = ncread(filePath, 'volumedepolarization'); catch volumedepolarization = NaN; end
            
                        dataStruct(countEligibleFiles).elda_measurement_start_datetime = ZuluToDate( elda_measurement_start_datetime);
                        dataStruct(countEligibleFiles).elda_measurement_stop_datetime = ZuluToDate( elda_measurement_stop_datetime);
                        dataStruct(countEligibleFiles).elda_altitude = elda_altitude;
                        % dataStruct(countEligibleFiles).wavelength = wavelength;
                        dataStruct(countEligibleFiles).input_file = input_file;
                        dataStruct(countEligibleFiles).backscatter = backscatter;
                        dataStruct(countEligibleFiles).error_backscatter = error_backscatter;
                        dataStruct(countEligibleFiles).extinction = extinction;
                        dataStruct(countEligibleFiles).error_extinction = error_extinction;
                        dataStruct(countEligibleFiles).volumedepolarization = volumedepolarization;
                    end
                    % busca los datos de referencia en el input file
        
                    countEligibleFiles = countEligibleFiles+1;
        
                % else 
                %     logMessage('False')
                %     logMessage(filePath)
                end
            end
    
            parts = strsplit(fileName, '_');
            
            
            % if contains(fileName,'elda')
                part_type = 'elda';
            % else
            %     part_type = 'unknow';
            % end
    
            % part_ubi = parts{1};
            % if part_ubi == 'brc'
                part_ubi = 'Barcelona';
            % end
        
            tmp = strsplit(fileName, '.');
            part_name = ['ELP_', parts{1}, '_', parts{2}, '_', parts{3}, '_', parts{4}, '_', parts{5}];
        
            tNames = evalin('base', 'WSTNames');
            newRow = {part_name, part_type, part_ubi};
            tNames{end+1, :} = newRow;
        
            assignin('base', 'WSTNames', tNames);
            
            % logMessage(tNames);
            % logMessage(dataStruct);
    
    
            dataTemp = struct2table(dataStruct);
            assignin('base', part_name, dataTemp);
            
        end

    % catch ME
    %    logMessage('Invalid Measure ID');
    %    logMessage(ME.identifier);
    %    logMessage(ME.message);
    %    foundFiles = 0;
    % end
end
