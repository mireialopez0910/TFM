function [tFiltered, numItems] = getFilteredTable( type, idx)

    logMessage(['ENTERING FILTER: type ', type]);

    %Busca el nombre de la tabla Elda para cargarla
    elda_name = getWSTNByType( 'elda' ).table_name{1};
    
    %Carga la tabla ELDA
    tEldaElpp = evalin('base', elda_name);                
    
    % tFiltered = tEldaElpp(startsWith(tEldaElpp.wavelength, 'brc_008'), :);

    tFiltered = table();

    [uniqueCategories, ia] = unique(tEldaElpp.wavelength, 'stable');
    tFiltered = tEldaElpp(ia, :);


    numItems=(num2str(height(tFiltered)));
    
    date_ini = tEldaElpp.elda_measurement_start_datetime;
    date_end = tEldaElpp.elda_measurement_stop_datetime;

    %date_ini = datetime(tEldaElpp.elda_measurement_start_datetime, "InputFormat",'yyyy-MM-dd HH:mm:ss');
    %date_end = datetime(tEldaElpp.elda_measurement_stop_datetime, "InputFormat",'yyyy-MM-dd HH:mm:ss');
    
    
    % logMessage(date_ini(1))
    % logMessage(date_end(1))
    


    if strcmpi(type,'elda')
        logMessage([type, ':', numItems]);
    else
        
        %Busca el nombre de la tabla Elda para cargarla
        tName = getWSTNByType(type).table_name{idx};
                
        %Carga la tabla ELDA
        tData = evalin('base', tName);
        
        
        filter = tData.FullDate >= date_ini(1) & tData.FullDate <= date_end(1);
        tFiltered = tData(filter, :);

        numItems = (num2str(height(tFiltered)));
        logMessage([type, ':', numItems]);
        % logMessage(tData)
       
    end

end

