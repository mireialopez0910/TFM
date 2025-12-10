function clearWSTNByType(table_type)
%%! clearWSTNByType(table_type)
%%! Descripció
%!
%! Esborra les files que compleixen amb la tipologia definida en el paràmetre
%! d'entrada 'table_type' a la taula d'assignació de noms de perfils ELDA/ELPP
%! a l'espai de treball (Workspace)
%! 
%! Possibles tipus de taula:
%! 
%! * 'lev15' - AOD Level 1.5
%! * 'alm' - Raw Almucantar
%! * 'all' - Almucantar Level 1.5 Inversion
%! * 'alp' - Raw Polarized Almucantar
%! * 'elda' - LIDAR Elda/Elpp
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |table_type: [string]| -
%!      tipus de registre (tipus de taula) que es vol netejar de la taula de noms ELDA/ELPP
%! 
%! *VALORS DE RETORN*
%!
%! No retorna cap valor.


    tEldaElpp = evalin('base', 'WSTNames');
    filtro = strcmp(tEldaElpp.type, table_type);
    filas_filtradas = tEldaElpp(filtro, :);
    
    for k=1:height(filas_filtradas)
        nombreTabla = filas_filtradas.table_name{k};
        evalin('base', ['clear ' nombreTabla]);
    end
    
    filasNoCumplen = ~filtro;
    
    % Crear una nueva tabla sin las filas filtradas
    miTablaSinFilas = tEldaElpp(filasNoCumplen, :);

    assignin('base', 'WSTNames', miTablaSinFilas);

end
