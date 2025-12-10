function dataToPlot(app, path2datafile)
%%! dataToPlot(app, path2datafile)
%%! Descripció
%!
%! Converteix les dades d'un fitxer .mat que conté la informació
%! relativa a una gràfica i la representa al visor UIAxes de la
%! interfície.
%! 
%! *Configuració del fitxer |.mat|*
%!
%! * |dataFigureAxis[Cell Array]| -
%!      Array de cel·les amb un vector de dades que representa el
%!      conjunt de dades dun eix. Els vectors deixos han de ser
%!      proporcionats en parells de cel·les (X,Y).
%! * |dataFigureColor[Cell Array]| - Array de cel·les amb un vector de dades
%!      que representa el color de cada parell de cel·les dels eixos.
%! * |dataFigureYLabel[string]| -
%!      Descripció de l'eix Y de la gràfica.
%! * |dataFigureXLabel[string]| -
%!      Descripció de l'eix X de la gràfica.
%! * |dataFigureXLim[float,float]| -
%!      Defineix el límit mínim i màxim de la gràfica per a l'eix X.
%! * |dataFigureYLim[float,float]| -
%!      Defineix el límit mínim i màxim de la gràfica per a l'eix Y.
%! * |dataFigureLegend|[Cell Array]| -
%!      Descripció per a les llegendes de cada parell de vectors de dades de la gràfica.
%! * |dataFigureTitle[string]| -
%!      Descripció per al títol de la gràfica.
%! * |dataFigureLogScale[Cell Array]| -
%! Dos valors de tipus cell que indiquen l'eix de l'escala i el tipus. Exemple: {'XScale', 'log'}.
%! En cas de no aplicar cap escala, deixar-lo buit '{}'
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%! 
%! * |path2datafile: [String]| -
%! Ruta i fitxer .mat que conté les dades per representar la gràfica
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!
    


    plotdata = load(path2datafile);    
    colors = plotdata.dataFigureColor;
    
    % Crear una nueva figura
    resetUIAxes(app);
    resetplotview(app);
    
    % Iterar sobre los pares de datos
    count = 1;
    for i = 1:2:length(plotdata.dataFigureAxis)
        x = plotdata.dataFigureAxis{i};       % Array x
        y = plotdata.dataFigureAxis{i + 1};   % Array y
        
        % Asegurarse de que ambos sean vectores columna
        if isrow(x)
            x = x';  % Transponer si es fila
        end
        if isrow(y)
            y = y';  % Transponer si es fila
        end
        
        % Graficar el par de datos
        hold(app.UIAxes, 'on');  % Mantener la gráfica para agregar más datos
        plot(app.UIAxes, x, y, colors{count});

        legend(app.UIAxes, plotdata.dataFigureLegend)
        count = count +1;
    end
    
    ylabel(app.UIAxes, plotdata.dataFigureYLabel);
    xlabel(app.UIAxes, plotdata.dataFigureXLabel);
    box(app.UIAxes, 'on');

    if ~isempty(plotdata.dataFigureXLim)
        xlim(app.UIAxes, [plotdata.dataFigureXLim(1), plotdata.dataFigureXLim(2)]);
    end


    if ~isempty(plotdata.dataFigureYLim)
        ylim(app.UIAxes, [plotdata.dataFigureYLim(1), plotdata.dataFigureYLim(2)]);
    end

    legend(app.UIAxes, 'boxoff');
    title (app.UIAxes, plotdata.dataFigureTitle);
    grid(app.UIAxes, 'on');
    
    if ~isempty(plotdata.dataFigureLogScale)
        set(app.UIAxes, plotdata.dataFigureLogScale(1), plotdata.dataFigureLogScale(2))
    end
end