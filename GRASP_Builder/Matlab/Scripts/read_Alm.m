function foundFiles = read_Alm(subfolderName)
%%! foundFiles = read_Alm(subfolderName)
%!
%%! Descripció
%!
%! Donada uma URL local, cerca els arxius de tipus ALM (Almucantar)
%! Afegeix una columna Datetime completa per facilitar les cerques i
%! torna els noms de les taules creades al Workspace
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |subfolderName: [string]| - 
%!      URL a la carpeta de fitxers ALM (Almucantar)
%!
%! *VALORS DE RETORN*
%!
%! * |foundFiles: [int]| - 
%!      Nombre de fitxers trobats que s'han processat
%!   
    files = dir( fullfile(subfolderName, '*.alm'));
    foundFiles = length(files);

    logMessage(['Aeronet ALM Files found; ', num2str(length(files))]);
    f = (length(files));

    workSpaceTableName = strings(1, 2);

    if ~isempty(files)

        for k = 1:f

            fullFileName = fullfile(subfolderName, files(k).name);
            fullFileName = char(fullFileName);  % convert to char if needed

            % Lectura del encabezado
            fid = fopen(fullFileName, 'r');
            headerLine1 = fgetl(fid);
            headerLine2 = fgetl(fid);
            headerLine3 = fgetl(fid);
            headerLine4 = fgetl(fid);
            headerLine5 = fgetl(fid);
            headerLine6 = fgetl(fid);
            headerLine7 = fgetl(fid);
            metaData1=fgetl(fid);
            metaData2=fgetl(fid);
            dataSample = fgetl(fid);
            dataSample = fgetl(fid);
            dataSample = fgetl(fid);
            dataSample = fgetl(fid);
            xxx = fgetl(fid);
    
    
            fclose(fid);
    
            headerLine1 = 'Almucantar';
            if(headerLine1 ==-1)
                logMessage('No data polarized found in ALM file')
            else
            headerLine3 = extractBefore(headerLine3,';');
        
            dataWorkSpaceLabel = strrep([headerLine1, '_', headerLine2, '_', headerLine3], ' ', '_');
            dataWorkSpaceLabel = strrep(dataWorkSpaceLabel, '.', '_');
            dataWorkSpaceLabel = strrep(dataWorkSpaceLabel, ':', '');
    
    
            
            
            % Definir un valor por defecto para campos vacíos
            valor_defecto = 'Empty';
            
            % Dividir las líneas por comas, incluyendo los campos vacíos, y asignar valor por defecto
            nombres_variables1 = split_and_fill_empty(metaData1, valor_defecto);

            nombres_variables2 = split_and_fill_empty(metaData2, valor_defecto);
            
            % Combinar los nombres de las variables en una sola fila
            nombres_variables = strcat(nombres_variables1, '_', nombres_variables2);
            
            % logMessage(['variables montadas: ', num2str(length(nombres_variables))])
            
            % Leer el archivo completo con readtable
            %opts.DataLines = [8, Inf];  % Empezar a leer desde la tercera línea
            %opts.VariableNamesLine = 6;  % Definir la primera línea como nombres de variables
            
            %opts.VariableNames = {'1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x'};
            %opts.VariableTypes = {'char','char','char','double','double','double','double','char','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};  
            
            opts = detectImportOptions(fullFileName, 'FileType', 'text', 'VariableNamingRule', 'preserve');
            opts.VariableNames = {'AERONET_Site','Date(dd:mm:yyyy)','Time(hh:mm:ss)','Instrument_Number','Nominal_Wavelength(nm)','Exact_Wavelength(um)','Solar_Zenith_Angle(Degrees)','Sky_Scan_Type','Latitude(Degrees)','Longitude(Degrees)','Elevation(m)','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_0.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-6.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-5.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-4.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-3.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-3.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-2.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-2.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_2.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_2.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_3.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_3.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_4.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_5.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_6.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_6.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_7.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_8.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_10.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_12.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_14.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_16.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_18.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_20.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_25.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_30.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_35.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_40.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_45.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_50.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_60.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_70.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_80.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_90.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_100.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_120.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_140.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_160.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_180.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-180.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-160.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-140.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-120.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-100.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-90.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-80.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-70.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-60.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-50.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-45.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-40.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-35.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-30.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-25.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-20.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-18.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-16.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-14.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-12.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-10.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-8.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-7.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-6.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-6.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-5.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-4.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-3.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-3.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-2.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-2.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_2.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_2.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_3.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_3.500','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_4.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_5.000','Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_6.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_0.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-6.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-5.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-4.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-3.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-3.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-2.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-2.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_2.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_2.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_3.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_3.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_4.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_5.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_6.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_6.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_7.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_8.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_10.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_12.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_14.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_16.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_18.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_20.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_25.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_30.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_35.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_40.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_45.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_50.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_60.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_70.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_80.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_90.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_100.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_120.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_140.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_160.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_180.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-180.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-160.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-140.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-120.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-100.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-90.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-80.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-70.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-60.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-50.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-45.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-40.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-35.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-30.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-25.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-20.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-18.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-16.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-14.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-12.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-10.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-8.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-7.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-6.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-6.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-5.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-4.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-3.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-3.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-2.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_-2.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_2.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_2.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_3.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_3.500','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_4.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_5.000','Scattering_Angle_for_Nominal_Azimuth_Angle(Degrees)_6.000'};
            opts.VariableTypes = {'char','char','char','double','double','double','double','char','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};  
            opts.DataLines = [9, Inf];  % Empezar a leer desde la tercera línea
    
            % Leer el archivo
            %opts2 = detectImportOptions(fullFileName, 'FileType', 'text', 'VariableNamingRule', 'preserve');
            %opts2.DataLines = [10, Inf];
            
            
            %opts2 = detectImportOptions(fullFileName, 'NumHeaderLines', 9); % Por ejemplo, ignorar las primeras 3 líneas
            
            datos = readtable(fullFileName, opts);
                        % Convertir la columna de fechas a datetime
                        % Convertir la columna de fechas a datetime
                fechas = datetime(datos.('Date(dd:mm:yyyy)'), 'InputFormat', 'dd:MM:yyyy');
    
                % Convertir la columna de horas a time
                horas = timeofday(datetime(datos.('Time(hh:mm:ss)'), 'InputFormat', 'HH:mm:ss'));
    
                fechaHoraUnificada = fechas + horas;
    
                % Añadir la nueva columna a la tabla original
                datos.FullDate = fechaHoraUnificada;
            
            % Asignar los nombres de variables combinados a la tabla
            %datos.Properties.VariableNames = nombres_variables(1:165);
    
            % Descompone el nombre del fichero para
            % guardarlo en la tabla de nombres
            
            temp1 = strsplit(files(k).name, '.');
            part_name = ['ALM_', temp1{1}];
    
            parts = strsplit(files(k).name, '_');
            temp = parts{3};
            parts = strsplit(temp, '.');
            part_ubi = 'barcelona'; %hardcoded
            part_type = 'alm'; %hardcoded
     
            tNames = evalin('base', 'WSTNames');
            newRow = {part_name, part_type, part_ubi};
            tNames{end+1, :} = newRow;
        
            %% Elimina columnas repetidas
            datos = removevars(datos, 'Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_6.000_1');
            datos = removevars(datos, 'Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-6.000_2');
            assignin('base', 'WSTNames', tNames);
    
            assignin('base', part_name, datos)
    
    % Mostrar la tabla
    % logMessage(datos);
            end
        end
    end
end

% Función para dividir la línea y capturar campos vacíos
function fields = split_and_fill_empty(line, default_value)
    % Inicializar el array de campos
    fields = {};
    % Inicializar el índice de campo
    field_index = 1;
    % Inicializar el buffer de caracteres
    buffer = '';
    % Recorrer cada carácter en la línea
    for i = 1:length(line)
        if line(i) == ','
            % Si se encuentra una coma, agregar el campo al array
            if isempty(buffer)
                fields{field_index} = default_value;
            else
                if length(buffer) > 50
                    fields{field_index} = buffer(1:50); 
                else
                    fields{field_index} = buffer;
                end
            end
            % Resetear el buffer y aumentar el índice
            buffer = '';
            field_index = field_index + 1;
        else
            % Si no es una coma, agregar el carácter al buffer
            buffer = [buffer line(i)];
        end
    end
    % Agregar el último campo (después de la última coma)
    if isempty(buffer)
        fields{field_index} = default_value;
    else
        fields{field_index} = buffer;
    end
end