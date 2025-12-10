function [altitudes, total_power_channels, cross_polarization_channels] = processNetCDFFiles(subfolderName)
    % Inicializar las salidas como celdas
    altitudes = {};
    total_power_channels = {};
    cross_polarization_channels = {};

    % Obtener la lista de archivos .nc en la subcarpeta
    files = dir(fullfile(subfolderName, '*.nc'));

    % Recorrer todos los archivos
    for k = 1:length(files)
        % Obtener el nombre del archivo
        fileName = files(k).name;
        
        % Verificar si el nombre del archivo comienza con 'brc_003' o 'brc_008'
        if startsWith(fileName, 'brc_003') || startsWith(fileName, 'brc_008')
            % Construir la ruta completa del archivo
            filePath = fullfile(subfolderName, fileName);
            
            % Leer la variable polarization_channel_geometry
            polarization_channel_geometry = ncread(filePath, 'polarization_channel_geometry');
            
            % Leer la variable range_corrected_signal
            range_corrected_signal = ncread(filePath, 'range_corrected_signal');
            
            % Leer la variable altitude
            altitude = ncread(filePath, 'altitude');
            
            % Determinar los canales basados en el flag en la primera fila de polarization_channel_geometry
            flag = polarization_channel_geometry(1);
            
            if flag == 1
                % Si el flag es igual a 1, la potencia total está en el primer canal (3ra dimensión)
                total_power_channel = squeeze(range_corrected_signal(:, 1, 1));
                cross_polarization_channel = squeeze(range_corrected_signal(:, 1, 2));
            elseif flag == 2
                % Si el flag es igual a 2, la polarización cruzada está en el primer canal (3ra dimensión)
                cross_polarization_channel = squeeze(range_corrected_signal(:, 1, 1));
                total_power_channel = squeeze(range_corrected_signal(:, 1, 2));
            else
                error('Valor de flag no esperado: %d', flag);
            end
            
            % Almacenar los resultados en las celdas
            altitudes{end+1} = altitude;
            total_power_channels{end+1} = total_power_channel;
            cross_polarization_channels{end+1} = cross_polarization_channel;
        end
    end
end
