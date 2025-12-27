function foundFiles = read_Alp(subfolderName)
%%! foundFiles = read_Alp(subfolderName)
%!
%%! Descripció
%!
%! Donada uma URL local, cerca els arxius de tipus ALP (Almucantar polaritzat)
%! Afegeix una columna Datetime completa per facilitar les cerques i
%! torna els noms de les taules creades al Workspace
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |subfolderName: [string]| - 
%!      URL a la carpeta de fitxers ALP (Almucantar polaritzat)
%!
%! *VALORS DE RETORN*
%!
%! * |foundFiles: [int]| - 
%!      Nombre de fitxers trobats que s'han processat
%! 
    files = dir( fullfile(subfolderName, '*.alp'));
    foundFiles = length(files);

    logMessage(['Aeronet ALP Files found; ', num2str(length(files))]);
  
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
            headerLine7 = fgetl(fid);
            metaData1=fgetl(fid);
            metaData2=fgetl(fid);
            dataSample = fgetl(fid);
            dataSample = fgetl(fid);
            dataSample = fgetl(fid);
            dataSample = fgetl(fid);
            xxx = fgetl(fid);
    
    
            fclose(fid);
    
            headerLine1 = 'Almucantar_polarized';
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
            
%             logMessage('variables montadas alp:')
%             
%             
%             for i = 1:length(nombres_variables)
%                 aaa = nombres_variables(i);
%                 
%                 logMessage( strcat("'", '(double)', "',") );
%             end


            % Leer el archivo completo con readtable
            %opts.DataLines = [8, Inf];  % Empezar a leer desde la tercera línea
            %opts.VariableNamesLine = 6;  % Definir la primera línea como nombres de variables
            
            %opts.VariableNames = {'1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x','6x','7x','8x','9x','0x','1x','2x','3x','4x','5x'};
            %opts.VariableTypes = {'char','char','char','double','double','double','double','char','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};  
            
            opts = detectImportOptions(fullFileName, 'FileType', 'text', 'VariableNamingRule', 'preserve');
            opts.VariableNames = {'AERONET_Site','Date(dd-mm-yyyy)','Time(hh:mm:ss)','Device_Number','Nominal_Wavelength(nm)','Exact_Wavelength(um)','Solar_Zenith_Angle','Sky_Scan_Type','Latitude(Degrees)','Longitude(Degrees)','Elevation(m)','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-160','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-140','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-120','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-110','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-100','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-90','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-80','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-70','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-60','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-50','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-45','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-40','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-35','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-30','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_-25','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_25','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_30','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_35','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_40','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_45','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_50','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_60','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_70','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_80','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_90','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_100','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_110','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_120','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_140','Degree_of_Polarization_for_Azimuth_Angle_in_Degree_160','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-160',...
                                  'P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-140','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-120','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-110','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-100','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-90','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-80','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-70','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-60','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-50','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-45','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-40','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-35','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-30','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-25','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_25','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_30','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_35','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_40','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_45','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_50','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_60','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_70','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_80','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_90','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_100','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_110','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_120','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_140','P1_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_160','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-160','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-140','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-120','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-110','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-100','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-90','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-80','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-70','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-60','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-50','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-45','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-40','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-35','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-30','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-25','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_25','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_30','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_35','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_40','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_45','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_50','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_60','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_70','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_80','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_90','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_100','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_110','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_120','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_140','P2_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_160','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-160','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-140','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-120','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-110','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-100','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-90','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-80','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-70','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-60','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-50','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-45','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-40','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-35','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-30','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_-25','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_25','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_30','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_35','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_40','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_45','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_50','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_60','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_70','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_80','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_90','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_100','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_110','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_120','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_140','P3_Radiance_for_Azimuth_Angle_in_Degrees[uW/cm^2/s_160','Scattering_Angle_for_Azimuth_Angle(Degrees)_-160','Scattering_Angle_for_Azimuth_Angle(Degrees)_-140','Scattering_Angle_for_Azimuth_Angle(Degrees)_-120','Scattering_Angle_for_Azimuth_Angle(Degrees)_-110','Scattering_Angle_for_Azimuth_Angle(Degrees)_-100','Scattering_Angle_for_Azimuth_Angle(Degrees)_-90','Scattering_Angle_for_Azimuth_Angle(Degrees)_-80','Scattering_Angle_for_Azimuth_Angle(Degrees)_-70','Scattering_Angle_for_Azimuth_Angle(Degrees)_-60','Scattering_Angle_for_Azimuth_Angle(Degrees)_-50','Scattering_Angle_for_Azimuth_Angle(Degrees)_-45','Scattering_Angle_for_Azimuth_Angle(Degrees)_-40','Scattering_Angle_for_Azimuth_Angle(Degrees)_-35','Scattering_Angle_for_Azimuth_Angle(Degrees)_-30','Scattering_Angle_for_Azimuth_Angle(Degrees)_-25','Scattering_Angle_for_Azimuth_Angle(Degrees)_25','Scattering_Angle_for_Azimuth_Angle(Degrees)_30','Scattering_Angle_for_Azimuth_Angle(Degrees)_35','Scattering_Angle_for_Azimuth_Angle(Degrees)_40','Scattering_Angle_for_Azimuth_Angle(Degrees)_45','Scattering_Angle_for_Azimuth_Angle(Degrees)_50','Scattering_Angle_for_Azimuth_Angle(Degrees)_60','Scattering_Angle_for_Azimuth_Angle(Degrees)_70','Scattering_Angle_for_Azimuth_Angle(Degrees)_80','Scattering_Angle_for_Azimuth_Angle(Degrees)_90','Scattering_Angle_for_Azimuth_Angle(Degrees)_100','Scattering_Angle_for_Azimuth_Angle(Degrees)_110','Scattering_Angle_for_Azimuth_Angle(Degrees)_120','Scattering_Angle_for_Azimuth_Angle(Degrees)_140','Scattering_Angle_for_Azimuth_Angle(Degrees)_160','Elevation_Angle_for_Azimuth_Angle(Degrees)_-160','Elevation_Angle_for_Azimuth_Angle(Degrees)_-140','Elevation_Angle_for_Azimuth_Angle(Degrees)_-120','Elevation_Angle_for_Azimuth_Angle(Degrees)_-110','Elevation_Angle_for_Azimuth_Angle(Degrees)_-100','Elevation_Angle_for_Azimuth_Angle(Degrees)_-90','Elevation_Angle_for_Azimuth_Angle(Degrees)_-80','Elevation_Angle_for_Azimuth_Angle(Degrees)_-70','Elevation_Angle_for_Azimuth_Angle(Degrees)_-60','Elevation_Angle_for_Azimuth_Angle(Degrees)_-50','Elevation_Angle_for_Azimuth_Angle(Degrees)_-45','Elevation_Angle_for_Azimuth_Angle(Degrees)_-40','Elevation_Angle_for_Azimuth_Angle(Degrees)_-35','Elevation_Angle_for_Azimuth_Angle(Degrees)_-30','Elevation_Angle_for_Azimuth_Angle(Degrees)_-25','Elevation_Angle_for_Azimuth_Angle(Degrees)_25','Elevation_Angle_for_Azimuth_Angle(Degrees)_30','Elevation_Angle_for_Azimuth_Angle(Degrees)_35','Elevation_Angle_for_Azimuth_Angle(Degrees)_40','Elevation_Angle_for_Azimuth_Angle(Degrees)_45','Elevation_Angle_for_Azimuth_Angle(Degrees)_50','Elevation_Angle_for_Azimuth_Angle(Degrees)_60','Elevation_Angle_for_Azimuth_Angle(Degrees)_70','Elevation_Angle_for_Azimuth_Angle(Degrees)_80','Elevation_Angle_for_Azimuth_Angle(Degrees)_90','Elevation_Angle_for_Azimuth_Angle(Degrees)_100','Elevation_Angle_for_Azimuth_Angle(Degrees)_110','Elevation_Angle_for_Azimuth_Angle(Degrees)_120','Elevation_Angle_for_Azimuth_Angle(Degrees)_140','Elevation_Angle_for_Azimuth_Angle(Degrees)_160','Azimuth_Angle(Degrees)_-160','Azimuth_Angle(Degrees)_-140','Azimuth_Angle(Degrees)_-120','Azimuth_Angle(Degrees)_-110','Azimuth_Angle(Degrees)_-100','Azimuth_Angle(Degrees)_-90','Azimuth_Angle(Degrees)_-80','Azimuth_Angle(Degrees)_-70','Azimuth_Angle(Degrees)_-60','Azimuth_Angle(Degrees)_-50','Azimuth_Angle(Degrees)_-45','Azimuth_Angle(Degrees)_-40','Azimuth_Angle(Degrees)_-35','Azimuth_Angle(Degrees)_-30','Azimuth_Angle(Degrees)_-25','Azimuth_Angle(Degrees)_25','Azimuth_Angle(Degrees)_30','Azimuth_Angle(Degrees)_35','Azimuth_Angle(Degrees)_40','Azimuth_Angle(Degrees)_45','Azimuth_Angle(Degrees)_50','Azimuth_Angle(Degrees)_60','Azimuth_Angle(Degrees)_70','Azimuth_Angle(Degrees)_80','Azimuth_Angle(Degrees)_90','Azimuth_Angle(Degrees)_100','Azimuth_Angle(Degrees)_110','Azimuth_Angle(Degrees)_120','Azimuth_Angle(Degrees)_140','Azimuth_Angle(Degrees)_160'};
            opts.VariableTypes = {'char','char','char','double','double','double','double','char','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double','double'};  
            opts.DataLines = [9, Inf];  % Empezar a leer desde la tercera línea
    
            % Leer el archivo
            %opts2 = detectImportOptions(fullFileName, 'FileType', 'text', 'VariableNamingRule', 'preserve');
            %opts2.DataLines = [10, Inf];
            
            
            %opts2 = detectImportOptions(fullFileName, 'NumHeaderLines', 9); % Por ejemplo, ignorar las primeras 3 líneas
            
            datos = readtable(fullFileName, opts);
                    
    
    
                % Convertir la columna de fechas a datetime
                fechas = datetime(datos.('Date(dd-mm-yyyy)'), 'InputFormat', 'dd:MM:yyyy');
    
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
            part_name = ['ALP_', temp1{1}];
    
            parts = strsplit(files(k).name, '_');
            temp = parts{3};
            parts = strsplit(temp, '.');
            part_ubi = 'barcelona'; %hardcoded
            part_type = 'alp'; %hardcoded
     
            tNames = evalin('base', 'WSTNames');
            newRow = {part_name, part_type, part_ubi};
            tNames{end+1, :} = newRow;
        
            assignin('base', 'WSTNames', tNames);
    
            assignin('base', part_name, datos)
            
    
    
    
    % Mostrar la tabla
    % logMessage(datos);
    
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