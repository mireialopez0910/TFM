function foundFiles = read_Aeronet(subfolderName)
%%! foundFiles = read_Aeronet(subfolderName)
%!
%%! Descripció
%!
%! Donada uma URL local, cerca els arxius de tipus LEV15
%! Afegeix una columna Datetime completa per facilitar les cerques i
%! torna els noms de les taules creades al Workspace
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |subfolderName: [string]| - 
%!      URL a la carpeta de fitxers AOD (*.lev15)
%!
%! *VALORS DE RETORN*
%!
%! * |foundFiles: [int]| - 
%!      Nombre de fitxers trobats que s'han processat
%!

    files = dir( fullfile(subfolderName, '*.lev15'));
    foundFiles = length(files);
    
    logMessage(['Aeronet lev15 Files found; ', num2str(length(files))]);

    workSpaceTableName = strings(1, 2);

    if ~isempty(files)

        for k = 1:length(files)
            % fullFileName = [subfolderName, files(k).name]
            % fullFileName = string(subfolderName) + string(files(k).name)

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
            fclose(fid);
    
            %build DataName using file-info
    
            headerLine1 = 'Aeronet';
            headerLine3 = extractBefore(headerLine3,';');
    
            dataWorkSpaceLabel = strrep([headerLine1, '_', headerLine2, '_', headerLine3], ' ', '_');
            dataWorkSpaceLabel = strrep(dataWorkSpaceLabel, '.', '_');
            dataWorkSpaceLabel = strrep(dataWorkSpaceLabel, ':', '');
    
    
            % logMessage('Loading lev15 data');        
            % logMessage('----------------------------');        
            % logMessage(['File: ', fullFileName]);
            % logMessage('----------------------------');        
            % logMessage(headerLine1);
            % logMessage(headerLine2);
            % logMessage(headerLine3);
            % logMessage(headerLine4);
            % logMessage(headerLine5);
            % logMessage(headerLine6);
    
    
            % Especifica las opciones de importación manualmente
            opts = delimitedTextImportOptions('Delimiter', ',');
            opts.DataLines = [8, Inf];
    
            opts.VariableNames = {'AERONET_Site','Date(dd:mm:yyyy)','Time(hh:mm:ss)','Day_of_Year','Day_of_Year(Fraction)','AOD_1640nm','AOD_1020nm','AOD_870nm','AOD_865nm','AOD_779nm','AOD_675nm','AOD_667nm','AOD_620nm','AOD_560nm','AOD_555nm','AOD_551nm','AOD_532nm','AOD_531nm','AOD_510nm','AOD_500nm','AOD_490nm','AOD_443nm','AOD_440nm','AOD_412nm','AOD_400nm','AOD_380nm','AOD_340nm','Precipitable_Water(cm)','AOD_681nm','AOD_709nm','AOD_Empty','AOD_Empty','AOD_Empty','AOD_Empty','AOD_Empty','Triplet_Variability_1640','Triplet_Variability_1020','Triplet_Variability_870','Triplet_Variability_865','Triplet_Variability_779','Triplet_Variability_675','Triplet_Variability_667','Triplet_Variability_620','Triplet_Variability_560','Triplet_Variability_555','Triplet_Variability_551','Triplet_Variability_532','Triplet_Variability_531','Triplet_Variability_510','Triplet_Variability_500','Triplet_Variability_490','Triplet_Variability_443','Triplet_Variability_440','Triplet_Variability_412','Triplet_Variability_400','Triplet_Variability_380','Triplet_Variability_340','Triplet_Variability_Precipitable_Water(cm)','Triplet_Variability_681','Triplet_Variability_709','Triplet_Variability_AOD_Empty','Triplet_Variability_AOD_Empty','Triplet_Variability_AOD_Empty','Triplet_Variability_AOD_Empty','Triplet_Variability_AOD_Empty','440-870_Angstrom_Exponent','380-500_Angstrom_Exponent','440-675_Angstrom_Exponent','500-870_Angstrom_Exponent','340-440_Angstrom_Exponent','440-675_Angstrom_Exponent[Polar]','Data_Quality_Level','AERONET_Instrument_Number','AERONET_Site_Name','Site_Latitude(Degrees)','Site_Longitude(Degrees)','Site_Elevation(m)','Solar_Zenith_Angle(Degrees)','Optical_Air_Mass','Sensor_Temperature(Degrees_C)','Ozone(Dobson)','NO2(Dobson)','Last_Date_Processed','Number_of_Wavelengths','Exact_Wavelengths_of_AOD(um)_1640nm','Exact_Wavelengths_of_AOD(um)_1020nm','Exact_Wavelengths_of_AOD(um)_870nm','Exact_Wavelengths_of_AOD(um)_865nm','Exact_Wavelengths_of_AOD(um)_779nm','Exact_Wavelengths_of_AOD(um)_675nm','Exact_Wavelengths_of_AOD(um)_667nm','Exact_Wavelengths_of_AOD(um)_620nm','Exact_Wavelengths_of_AOD(um)_560nm','Exact_Wavelengths_of_AOD(um)_555nm','Exact_Wavelengths_of_AOD(um)_551nm','Exact_Wavelengths_of_AOD(um)_532nm','Exact_Wavelengths_of_AOD(um)_531nm','Exact_Wavelengths_of_AOD(um)_510nm','Exact_Wavelengths_of_AOD(um)_500nm','Exact_Wavelengths_of_AOD(um)_490nm','Exact_Wavelengths_of_AOD(um)_443nm','Exact_Wavelengths_of_AOD(um)_440nm','Exact_Wavelengths_of_AOD(um)_412nm','Exact_Wavelengths_of_AOD(um)_400nm','Exact_Wavelengths_of_AOD(um)_380nm','Exact_Wavelengths_of_AOD(um)_340nm','Exact_Wavelengths_of_PW(um)_935nm','Exact_Wavelengths_of_AOD(um)_681nm','Exact_Wavelengths_of_AOD(um)_709nm','Exact_Wavelengths_of_AOD(um)_Empty','Exact_Wavelengths_of_AOD(um)_Empty','Exact_Wavelengths_of_AOD(um)_Empty','Exact_Wavelengths_of_AOD(um)_Empty','Exact_Wavelengths_of_AOD(um)_Empty'};
            opts.VariableTypes = {'char','char','char','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};  
    
            tmp_table = readtable( fullFileName, opts);


            % Convertir la columna de fechas a datetime
            fechas = datetime(tmp_table.Date_dd_mm_yyyy_, 'InputFormat', 'dd:MM:yyyy');

            % Convertir la columna de horas a time
            horas = timeofday(datetime(tmp_table.Time_hh_mm_ss_, 'InputFormat', 'HH:mm:ss'));

            fechaHoraUnificada = fechas + horas;

            % Añadir la nueva columna a la tabla original
            tmp_table.FullDate = fechaHoraUnificada;

    
            % Descompone el nombre del fichero para
            % guardarlo en la tabla de nombres
            
            temp1 = strsplit(files(k).name, '.');
            part_type = char(temp1(2));
            part_name = ['AOD_', temp1{1}];
            parts = strsplit(temp1{1}, '_');
            part_ubi = char(parts(3));
            
     
            tNames = evalin('base', 'WSTNames');
            newRow = {part_name, part_type, part_ubi};
            tNames{end+1, :} = newRow;
        
            assignin('base', 'WSTNames', tNames);
            assignin('base', part_name, tmp_table)
        end
    end
end