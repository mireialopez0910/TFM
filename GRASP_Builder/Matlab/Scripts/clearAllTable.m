function clearAllTable()
%%! clearAllTable()
%%! DESCRIPCIÓ
%!
%! Obté els noms de totes les taules existents al Workspace i les esborra
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * No es requereixen paràmetres d'entrada
%!
%!
%! *VALORS DE RETORN*
%!
%! No torna cap valor
%!

    vars = evalin('base', 'whos');  % Obtiene todas las variables en el workspace base
    for k = 1:length(vars)
        if strcmp(vars(k).class, 'table')  % Verifica si la variable es de tipo 'table'
            evalin('base', ['clear ' vars(k).name]);  % Borrar la tabla del workspace
        end
    end
end

