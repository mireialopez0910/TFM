function foundFiles = read_All(subfolderName)
%%! foundFiles = read_All(subfolderName)
%!
%%! Descripció
%!
%! Donada uma URL local, cerca els arxius de tipus ALL
%! Afegeix una columna Datetime completa per facilitar les cerques i
%! torna els noms de les taules creades al Workspace
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |subfolderName: [string]| - 
%!      URL a la carpeta de fitxers ALL
%!
%! *VALORS DE RETORN*
%!
%! * |foundFiles: [int]| - 
%!      Nombre de fitxers trobats que s'han processat
%!
    files = dir( fullfile(subfolderName, '*.all'));
    foundFiles = length(files);

    logMessage(['Aeronet ALL Files found; ', num2str(length(files))]);

    workSpaceTableName = strings(1, 2);

    if ~isempty(files)

        for k = 1:length(files)

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
            metaData1=fgetl(fid);
            fclose(fid);
    
            headerLine1 = 'ALL Almucantar';
            if(headerLine2 ==-1)
                logMessage('No data polarized found in ALL file')
            else
            headerLine3 = extractBefore(headerLine3,';');
        
            dataWorkSpaceLabel = strrep([headerLine1, '_', headerLine2, '_', headerLine3], ' ', '_');
            dataWorkSpaceLabel = strrep(dataWorkSpaceLabel, '.', '_');
            dataWorkSpaceLabel = strrep(dataWorkSpaceLabel, ':', '');
    
            
            % Leer el archivo completo con readtable
            %opts.DataLines = [8, Inf];  % Empezar a leer desde la tercera línea
            %opts.VariableNamesLine = 6;  % Definir la primera línea como nombres de variables
            
            
            opts = detectImportOptions(fullFileName, 'FileType', 'text', 'VariableNamingRule', 'preserve');
    
            %ORIGINAL VAR_NAMES
            %opts.VariableNames = {'Site','Date(dd:mm:yyyy)','Time(hh:mm:ss)','Day_of_Year','Day_of_Year(Fraction)','AOD_Coincident_Input[440nm]','AOD_Coincident_Input[675nm]','AOD_Coincident_Input[870nm]','AOD_Coincident_Input[1020nm]','Angstrom_Exponent_440-870nm_from_Coincident_Input_AOD','AOD_Extinction-Total[440nm]','AOD_Extinction-Total[675nm]','AOD_Extinction-Total[870nm]','AOD_Extinction-Total[1020nm]','AOD_Extinction-Fine[440nm]','AOD_Extinction-Fine[675nm]','AOD_Extinction-Fine[870nm]','AOD_Extinction-Fine[1020nm]','AOD_Extinction-Coarse[440nm]','AOD_Extinction-Coarse[675nm]','AOD_Extinction-Coarse[870nm]','AOD_Extinction-Coarse[1020nm]','Extinction_Angstrom_Exponent_440-870nm-Total','Single_Scattering_Albedo[440nm]','Single_Scattering_Albedo[675nm]','Single_Scattering_Albedo[870nm]','Single_Scattering_Albedo[1020nm]','Absorption_AOD[440nm]','Absorption_AOD[675nm]','Absorption_AOD[870nm]','Absorption_AOD[1020nm]','Absorption_Angstrom_Exponent_440-870nm','Refractive_Index-Real_Part[440nm]','Refractive_Index-Real_Part[675nm]','Refractive_Index-Real_Part[870nm]','Refractive_Index-Real_Part[1020nm]','Refractive_Index-Imaginary_Part[440nm]','Refractive_Index-Imaginary_Part[675nm]','Refractive_Index-Imaginary_Part[870nm]','Refractive_Index-Imaginary_Part[1020nm]','Asymmetry_Factor-Total[440nm]','Asymmetry_Factor-Total[675nm]','Asymmetry_Factor-Total[870nm]','Asymmetry_Factor-Total[1020nm]','Asymmetry_Factor-Fine[440nm]','Asymmetry_Factor-Fine[675nm]','Asymmetry_Factor-Fine[870nm]','Asymmetry_Factor-Fine[1020nm]','Asymmetry_Factor-Coarse[440nm]','Asymmetry_Factor-Coarse[675nm]','Asymmetry_Factor-Coarse[870nm]','Asymmetry_Factor-Coarse[1020nm]','Sphericity_Factor(%)','0.050000','0.065604','0.086077','0.112939','0.148184','0.194429','0.255105','0.334716','0.439173','0.576227','0.756052','0.991996','1.301571','1.707757','2.240702','2.939966','3.857452','5.061260','6.640745','8.713145','11.432287','15.000000','Inflection_Radius_of_Size_Distribution(um)','VolC-T','REff-T','VMR-T','Std-T','VolC-F','REff-F','VMR-F','Std-F','VolC-C','REff-C','VMR-C','Std-C','Minimum_Altitude_For_Flux_Calculations(km)','Maximum_Altitude_For_Flux_Calculations(km)','Flux_Down(BOA)','Flux_Down(TOA)','Flux_Up(BOA)','Flux_Up(TOA)','Rad_Forcing(BOA)','Rad_Forcing(TOA)','Forcing_Eff(BOA)','Forcing_Eff(TOA)','Diffuse(BOA)','Diffuse(TOA)','Spectral_Flux_Down[440nm]','Spectral_Flux_Down[675nm]','Spectral_Flux_Down[870nm]','Spectral_Flux_Down[1020nm]','Spectral_Flux_Up[440nm]','Spectral_Flux_Up[675nm]','Spectral_Flux_Up[870nm]','Spectral_Flux_Up[1020nm]','Spectral_Flux_Diffuse[440nm]','Spectral_Flux_Diffuse[675nm]','Spectral_Flux_Diffuse[870nm]','Spectral_Flux_Diffuse[1020nm]','Lidar_Ratio[440nm]','Lidar_Ratio[675nm]','Lidar_Ratio[870nm]','Lidar_Ratio[1020nm]','Depolarization_Ratio[440nm]','Depolarization_Ratio[675nm]','Depolarization_Ratio[870nm]','Depolarization_Ratio[1020nm]','Average_Solar_Zenith_Angles_for_Flux_Calculation(Degrees)','Solar_Zenith_Angle_for_Measurement_Start(Degrees)','Sky_Residual(%)','Sun_Residual(%)','Coincident_AOD440nm','Scattering_Angle_Bin_3.2_to_<6_degrees[440nm]','Scattering_Angle_Bin_6_to_<30_degrees[440nm]','Scattering_Angle_Bin_30_to_<80_degrees[440nm]','Scattering_Angle_Bin_80_degrees_and_over[440nm]','Scattering_Angle_Bin_3.2_to_<6_degrees[675nm]','Scattering_Angle_Bin_6_to_<30_degrees[675nm]','Scattering_Angle_Bin_30_to_<80_degrees[675nm]','Scattering_Angle_Bin_80_degrees_and_over[675nm]','Scattering_Angle_Bin_3.2_to_<6_degrees[870nm]','Scattering_Angle_Bin_6_to_<30_degrees[870nm]','Scattering_Angle_Bin_30_to_<80_degrees[870nm]','Scattering_Angle_Bin_80_degrees_and_over[870nm]','Scattering_Angle_Bin_3.2_to_<6_degrees[1020nm]','Scattering_Angle_Bin_6_to_<30_degrees[1020nm]','Scattering_Angle_Bin_30_to_<80_degrees[1020nm]','Scattering_Angle_Bin_80_degrees_and_over[1020nm]','Surface_Albedo[440m]','Surface_Albedo[675m]','Surface_Albedo[870m]','Surface_Albedo[1020m]','If_Retrieval_is_L2(without_L2_0.4_AOD_440_threshold)','If_AOD_is_L2','Last_Processing_Date(dd:mm:yyyy)','Last_Processing_Time(hh:mm:ss)','Instrument_Number','Latitude(Degrees)','Longitude(Degrees)','Elevation(m)','Inversion_Data_Quality_Level','Retrieval_Measurement_Scan_Type'};
    
            % STANDARIZED VAR_NAMES (change chars: '|','-','[',']' by '_')
            opts.VariableNames = {'Site','Date(dd:mm:yyyy)','Time(hh:mm:ss)','Day_of_Year','Day_of_Year(Fraction)','AOD_Coincident_Input_440nm','AOD_Coincident_Input_675nm','AOD_Coincident_Input_870nm','AOD_Coincident_Input_1020nm','Angstrom_Exponent_440_870nm_from_Coincident_Input_AOD','AOD_Extinction_Total_440nm','AOD_Extinction_Total_675nm','AOD_Extinction_Total_870nm','AOD_Extinction_Total_1020nm','AOD_Extinction_Fine_440nm','AOD_Extinction_Fine_675nm','AOD_Extinction_Fine_870nm','AOD_Extinction_Fine_1020nm','AOD_Extinction_Coarse_440nm','AOD_Extinction_Coarse_675nm','AOD_Extinction_Coarse_870nm','AOD_Extinction_Coarse_1020nm','Extinction_Angstrom_Exponent_440_870nm_Total','Single_Scattering_Albedo_440nm','Single_Scattering_Albedo_675nm','Single_Scattering_Albedo_870nm','Single_Scattering_Albedo_1020nm','Absorption_AOD_440nm','Absorption_AOD_675nm','Absorption_AOD_870nm','Absorption_AOD_1020nm','Absorption_Angstrom_Exponent_440_870nm','Refractive_Index_Real_Part_440nm','Refractive_Index_Real_Part_675nm','Refractive_Index_Real_Part_870nm','Refractive_Index_Real_Part_1020nm','Refractive_Index_Imaginary_Part_440nm','Refractive_Index_Imaginary_Part_675nm','Refractive_Index_Imaginary_Part_870nm','Refractive_Index_Imaginary_Part_1020nm','Asymmetry_Factor_Total_440nm','Asymmetry_Factor_Total_675nm','Asymmetry_Factor_Total_870nm','Asymmetry_Factor_Total_1020nm','Asymmetry_Factor_Fine_440nm','Asymmetry_Factor_Fine_675nm','Asymmetry_Factor_Fine_870nm','Asymmetry_Factor_Fine_1020nm','Asymmetry_Factor_Coarse_440nm','Asymmetry_Factor_Coarse_675nm','Asymmetry_Factor_Coarse_870nm','Asymmetry_Factor_Coarse_1020nm','Sphericity_Factor','0.050000','0.065604','0.086077','0.112939','0.148184','0.194429','0.255105','0.334716','0.439173','0.576227','0.756052','0.991996','1.301571','1.707757','2.240702','2.939966','3.857452','5.061260','6.640745','8.713145','11.432287','15.000000','Inflection_Radius_of_Size_Distribution(um)','VolC_T','REff_T','VMR_T','Std_T','VolC_F','REff_F','VMR_F','Std_F','VolC_C','REff_C','VMR_C','Std_C','Minimum_Altitude_For_Flux_Calculations(km)','Maximum_Altitude_For_Flux_Calculations(km)','Flux_Down(BOA)','Flux_Down(TOA)','Flux_Up(BOA)','Flux_Up(TOA)','Rad_Forcing(BOA)','Rad_Forcing(TOA)','Forcing_Eff(BOA)','Forcing_Eff(TOA)','Diffuse(BOA)','Diffuse(TOA)','Spectral_Flux_Down_440nm','Spectral_Flux_Down_675nm','Spectral_Flux_Down_870nm','Spectral_Flux_Down_1020nm','Spectral_Flux_Up_440nm','Spectral_Flux_Up_675nm','Spectral_Flux_Up_870nm','Spectral_Flux_Up_1020nm','Spectral_Flux_Diffuse_440nm','Spectral_Flux_Diffuse_675nm','Spectral_Flux_Diffuse_870nm','Spectral_Flux_Diffuse_1020nm','Lidar_Ratio_440nm','Lidar_Ratio_675nm','Lidar_Ratio_870nm','Lidar_Ratio_1020nm','Depolarization_Ratio_440nm','Depolarization_Ratio_675nm','Depolarization_Ratio_870nm','Depolarization_Ratio_1020nm','Average_Solar_Zenith_Angles_for_Flux_Calculation(Degrees)','Solar_Zenith_Angle_for_Measurement_Start(Degrees)','Sky_Residual(%)','Sun_Residual(%)','Coincident_AOD440nm','Scattering_Angle_Bin_3.2_to_<6_degrees_440nm','Scattering_Angle_Bin_6_to_<30_degrees_440nm','Scattering_Angle_Bin_30_to_<80_degrees_440nm','Scattering_Angle_Bin_80_degrees_and_over_440nm','Scattering_Angle_Bin_3.2_to_<6_degrees_675nm','Scattering_Angle_Bin_6_to_<30_degrees_675nm','Scattering_Angle_Bin_30_to_<80_degrees_675nm','Scattering_Angle_Bin_80_degrees_and_over_675nm','Scattering_Angle_Bin_3.2_to_<6_degrees_870nm','Scattering_Angle_Bin_6_to_<30_degrees_870nm','Scattering_Angle_Bin_30_to_<80_degrees_870nm','Scattering_Angle_Bin_80_degrees_and_over_870nm','Scattering_Angle_Bin_3.2_to_<6_degrees_1020nm','Scattering_Angle_Bin_6_to_<30_degrees_1020nm','Scattering_Angle_Bin_30_to_<80_degrees_1020nm','Scattering_Angle_Bin_80_degrees_and_over_1020nm','Surface_Albedo_440m','Surface_Albedo_675m','Surface_Albedo_870m','Surface_Albedo_1020m','If_Retrieval_is_L2(without_L2_0.4_AOD_440_threshold)','If_AOD_is_L2','Last_Processing_Date(dd:mm:yyyy)','Last_Processing_Time(hh:mm:ss)','Instrument_Number','Latitude(Degrees)','Longitude(Degrees)','Elevation(m)','Inversion_Data_Quality_Level','Retrieval_Measurement_Scan_Type'};
            opts.VariableTypes = {'char','char','char','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','char','char'};
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
            part_name = ['ALL_', temp1{1}];
    
            parts = strsplit(files(k).name, '_');
            temp = parts{3};
            parts = strsplit(temp, '.');
            part_ubi = 'barcelona'; %hardcoded
            part_type = 'all'; %hardcoded
     
            tNames = evalin('base', 'WSTNames');
            newRow = {part_name, part_type, part_ubi};
            tNames{end+1, :} = newRow;
        
            %% Elimina columnas repetidas
            %datos = removevars(datos, 'Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_6.000_1');
            %datos = removevars(datos, 'Radiance_for_Azimuth_Angle_in_Degrees(uW/cm^2/sr\nm)_-6.000_2');
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