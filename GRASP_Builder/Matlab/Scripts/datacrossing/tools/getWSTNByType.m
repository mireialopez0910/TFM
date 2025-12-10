function filas_filtradas = getWSTNByType( table_type )

    try
        tEldaElpp = evalin('base', 'WSTNames');
        filas_filtradas = tEldaElpp(strcmp(tEldaElpp.type, table_type), :);
    
    catch 
        filas_filtradas = 0;
    end
end