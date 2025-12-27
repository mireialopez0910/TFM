function resetUIAxes(app)
%%! resetUIAxes(app)
%!
%! Reinicia el visor UIAxes de la interfície:
%!
%! * Neteja l'eix de coordenades
%! * Restableix les etiquetes i els títols
%! * Restableix els límits
%! * Restableix la reixeta i la caixa
%! * Restableix les escales a 'lineals'

%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!

    % Limpiar el eje
    cla(app.UIAxes);
    
    % Restablecer etiquetas y títulos
    xlabel(app.UIAxes, '');
    ylabel(app.UIAxes, '');
    title(app.UIAxes, '');
    
    % Restablecer límites
    xlim(app.UIAxes, 'auto');
    ylim(app.UIAxes, 'auto');
    
    % Restablecer la rejilla y la caja
    grid(app.UIAxes, 'on'); % Desactivar la rejilla
    box(app.UIAxes, 'on'); % Desactivar la caja
    
    % Restablecer escalas a lineales
    set(app.UIAxes, 'XScale', 'linear'); % Restablecer escala X
    set(app.UIAxes, 'YScale', 'linear'); % Restablecer escala Y
end