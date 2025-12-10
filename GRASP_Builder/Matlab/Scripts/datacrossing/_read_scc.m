

% function  [RangeCorrectedSignal]=ExtractRangeCorrectedSignal (fileName)

% Especificar el nombre de la subcarpeta
subfolderName = '20221005brc3625';

% Obtener la lista de archivos en la subcarpeta
files = dir(fullfile(subfolderName, '*'));

%%003
channel_1=

% Recorrer todos los archivos
for k = 1:length(files)
    % Ignorar los directorios '.' y '..'
    if ~files(k).isdir
        % Obtener el nombre del archivo
        fileName = files(k).name;
        
        % Verificar si el nombre del archivo comienza con 'brc_003' o 'brc_008'
        if startsWith(fileName, 'brc_003') || startsWith(fileName, 'brc_008')
            % Crear la ruta completa al archivo
            filePath = fullfile(subfolderName, fileName);
            
            % Mostrar la información del archivo NetCDF
            disp(['Mostrando información de: ', filePath]);
            ncdisp(filePath);
            altitude=ncread(fileName, 'altitude')
            polarization_channel_geometry=ncread(filename, 'polarization_channel_geometry')
            
        end
    end
end


