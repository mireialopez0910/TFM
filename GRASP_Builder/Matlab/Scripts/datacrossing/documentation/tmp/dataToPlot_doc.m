%% dataToPlot(app, path2datafile)
%% Descripció
%
% Converteix les dades d'un fitxer .mat que conté la informació
% relativa a una gr&agrave;fica i la representa al visor UIAxes de la
% interfície.
%
% *Configuració del fitxer |.mat|*
%
% * |dataFigureAxis[Cell Array]| -
%      Array de cel·les amb un vector de dades que representa el
%      conjunt de dades dun eix. Els vectors deixos han de ser
%      proporcionats en parells de cel·les (X,Y).
% * |dataFigureColor[Cell Array]| - Array de cel·les amb un vector de dades
%      que representa el color de cada parell de cel·les dels eixos.
% * |dataFigureYLabel[string]| -
%      Descripció de l'eix Y de la gr&agrave;fica.
% * |dataFigureXLabel[string]| -
%      Descripció de l'eix X de la gr&agrave;fica.
% * |dataFigureXLim[float,float]| -
%      Defineix el límit mínim i m&agrave;xim de la gr&agrave;fica per a l'eix X.
% * |dataFigureYLim[float,float]| -
%      Defineix el límit mínim i m&agrave;xim de la gr&agrave;fica per a l'eix Y.
% * |dataFigureLegend|[Cell Array]| -
%      Descripció per a les llegendes de cada parell de vectors de dades de la gr&agrave;fica.
% * |dataFigureTitle[string]| -
%      Descripció per al títol de la gr&agrave;fica.
% * |dataFigureLogScale[Cell Array]| -
% Dos valors de tipus cell que indiquen l'eix de l'escala i el tipus. Exemple: {'XScale', 'log'}.
% En cas de no aplicar cap escala, deixar-lo buit '{}'
%
% *PARÀMETRES D'ENTRADA*
%
% * |app: [App object]| -
% Inst&agrave;ncia de la classe de l'aplicació que creeu
%
% * |path2datafile: [String]| -
% Ruta i fitxer .mat que conté les dades per representar la gr&agrave;fica
%
% *VALORS DE SORTIDA*
%
% * No torna cap valor
%
