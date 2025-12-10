%% findSpecificFolders(IdMeasure)
%% Descripció
%
% Indicant un ID de mesura (measureID), retorna la llista de subcarpetes on
% es troben els fitxers de cada possible configuració disponible per crear
% els seus gr&agrave;fics corresponents (plot).
%
% L'estructura és:
%
% [MeasureID] -> [config_type] - [MeasureID] - [Min Height] - [Max. Height]
%
% *PARÀMETRES D'ENTRADA*
%
% * |selectedIdMeasure: [string]| -
%      Identificador de la mesura que s'utilitzar&agrave; per identificar les carpetes que contenen cada configuració.
%
% *VALORS DE RETORN*
%
% * |specificFolders:[string[]]| -
%      Array de cadenes amb els noms de les subcarpetes de cada configuració.
%
