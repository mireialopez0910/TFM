
function foundFiles = read_NetCDF(measureID, Folder_LIDAR)
%%! foundFiles = read_NetCDF(measureID)
%!
%%! Descripció
%!
%! Donada un MeasureID, cerca els arxius de tipus '.nc' (Network Common Data Form)
%! les dades del qual facin referència a ELDA i continguin informació sobre les longituds d'ona 1064, 532, 355
%!
%! *Camps ELDA*
%!
%! * measurement_start_datetime
%! * measurement_stop_datetime      
%! * wavelength
%! * altitude
%! * input_file
%! * backscatter
%! * error_backscatter
%! * extinction
%! * error_extinction
%! * volumedepolarization

%! Usant el 'filename' de referència cerca el fitxer ELPP i extreu-ne els
%! camps necessaris.
%!
%! *Camps ELPP*
%! 
%! * measurement_start_datetime
%! * measurement_stop_datetime
%! * altitude
%! * range                    
%! * polarization_channel_geometry
%! * range_corrected_signal
%!               
%! Llegeix el flag de polarization_channel_geometry i determina el tipus de canal
%! basat en el flag:
% * Canal 1 (flag): Total Power Channel
% * Canal 2 (flag): Polarització Creuada
%!
%! Afegeix atributs addicionals com el color per a cada longitud d'ona:
%! 
%! * 1064 red
%! * 532  green
%! * 355  blue
%!
%! *Acciones adicionales*
%!
%! Crea un nom basat en la mesura seleccionada per desar-lo com
%! taula a l'espai de treball i se l'assigna a la taula de registre de
%! noms per poder recuperar-lo més endavant si cal.
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |subfolderName: [string]| - 
%!      URL a la carpeta de fitxers .nc (Network Common Data Form)
%!
%! *VALORS DE RETORN*
%!
%! * |foundFiles: [int]| - 
%!      Nombre de fitxers trobats que s'han processat
%! 
    % try
        
        addpath('tools');

        run('config_file.m');
        currentFolder = fileparts(mfilename('fullpath'));  
        URL_LIDAR = Folder_LIDAR+measureID+'/'
    
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
                filePath = fullfile(URL_LIDAR, fileName);
             
                if (contains(fileName, '_b1064_') || contains(fileName, '_b0532_') || contains(fileName, '_b0355_') || contains(fileName, '_b0354_')) && contains(fileName, 'elda') && ~contains(fileName, '_002_')
                    
                    % logMessage('True')
                    % logMessage(filePath)
                    % nclogMessage(filePath)
                    % Procesar campos en archivo tipo brc_003 y brc_008
                    
                    elda_measurement_start_datetime = ncreadatt(filePath,'/', 'measurement_start_datetime');
                    elda_measurement_stop_datetime = ncreadatt(filePath,'/', 'measurement_stop_datetime');
        
                    wavelength = ncread(filePath, 'wavelength');
                    elda_altitude = ncread(filePath, 'altitude');
                    input_file = ncreadatt(filePath,'/', 'input_file');
                    backscatter = ncread(filePath, 'backscatter');
                    error_backscatter = ncread(filePath, 'error_backscatter');
                    try extinction=ncread(filePath, 'extinction'); catch extinction = NaN; end
                    try error_extinction=ncread(filePath, 'error_extinction'); catch error_extinction = NaN; end
        
                    % Procesar campos en archivo tipo brc_008
                    try volumedepolarization = ncread(filePath, 'volumedepolarization'); catch volumedepolarization = NaN; end
        
                    dataStruct(countEligibleFiles).fileName = fileName;
                    dataStruct(countEligibleFiles).elda_measurement_start_datetime = ZuluToDate( elda_measurement_start_datetime);
                    dataStruct(countEligibleFiles).elda_measurement_stop_datetime = ZuluToDate( elda_measurement_stop_datetime);
                    dataStruct(countEligibleFiles).elda_altitude = elda_altitude;
                    dataStruct(countEligibleFiles).wavelength = wavelength;
                    dataStruct(countEligibleFiles).input_file = input_file;
                    dataStruct(countEligibleFiles).backscatter = backscatter;
                    dataStruct(countEligibleFiles).error_backscatter = error_backscatter;
                    dataStruct(countEligibleFiles).extinction = extinction;
                    dataStruct(countEligibleFiles).error_extinction = error_extinction;
                    dataStruct(countEligibleFiles).volumedepolarization = volumedepolarization;

                    % busca los datos de referencia en el input file

                    folder = URL_LIDAR;
                    searchString = num2str(floor(wavelength));

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


                    fileInputPath = foundFile;
                    
                    % Get file info
                    info = ncinfo(fileInputPath);
                    varNames = {info.Variables.Name};
                    % Save to a text file
                    fid = fopen('variable_list.txt','w');
                    for k = 1:numel(varNames)
                        fprintf(fid, '%s\n', varNames{k});
                    end
                    fclose(fid);

                    % logMessage('Read ELPP altitude and range from file:')
                    % logMessage(fileInputPath)
                    % nclogMessage(fileInputPath)
                    dataStruct(countEligibleFiles).elpp_measurement_start_datetime = ZuluToDate( ncreadatt(fileInputPath,'/', 'measurement_start_datetime') );
                    dataStruct(countEligibleFiles).elpp_measurement_stop_datetime = ZuluToDate( ncreadatt(fileInputPath,'/', 'measurement_stop_datetime') );
                    dataStruct(countEligibleFiles).elpp_altitude = ncread(fileInputPath, 'altitude');
                    dataStruct(countEligibleFiles).range = ncread(fileInputPath, 'range');
                    
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
        
        
                    % Add attribute
                    dataStruct(countEligibleFiles).attr_color = "black";
        
                    if contains(fileName, '_b1064_') 
                        dataStruct(countEligibleFiles).attr_color = "red";
                    end
        
                    if contains(fileName, '_b0532_')
                        dataStruct(countEligibleFiles).attr_color = "green";
                    end
        
                    if contains(fileName, '_b0355_') || contains(fileName, '_b0354_') 
                        dataStruct(countEligibleFiles).attr_color = "blue";
                    end
        
                    countEligibleFiles = countEligibleFiles+1;
        
                % else 
                %     logMessage('False')
                %     logMessage(filePath)
                end
            end
    
            parts = strsplit(fileName, '_');
            
            
            if contains(fileName,'elda')
                part_type = 'elda';
            else
                part_type = 'unknow';
            end
    
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
