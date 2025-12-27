function location = getLocationFromEldaFileName(filename)
%%! location = getLocationFromEldaFileName(filename)
%%! DESCRIPCIÓ
%!
%! Extrau el nom de l'estació analitzant el nom del fitxer. Per
%! convenció s'assumeix que el nom de l'estació es troba entre el
%! primer guió baix i el segon. Si no trobeu cap nom que compleixi
%! les regles retorna UNDEFINED
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |filename: [string]| -
%!      Nom del fitxer que cal analitzar.
%!
%!
%! *VALORS DE RETORN*
%!
%! * |location: [string]| -
%! Retorna el nom de l'estació. Si no extreu cap nom
%! torna 'UNDEFINED'
%! 

    location = 'UNDEFINED';
    % Encontrar la posición del primer carácter de subrayado
    underscoreIndex = strfind(filename, '_');
    
    % Extraer la parte antes del subrayado
    if ~isempty(underscoreIndex)
        location = upper(filename(1:underscoreIndex(1)-1) );
    end
end

