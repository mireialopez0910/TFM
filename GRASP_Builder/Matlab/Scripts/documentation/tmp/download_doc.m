%% [ErrorType, ErrorMessage, ID_measure] = download(ID_measure, Auth, idType)
%
%% Descripció
%
% La funció utilitza les credencials per connectar-se al servidor SCC i descarrega els
% fitxers ELDA/ELPP segons s'indiquin als par&agrave;metres d'entrada.
% El fitxer esperat haur&agrave; d'estar en format .zip i una vegada descarregat es
% descomprimeix al repositori corresponent (LIDAR).
% Si l'estructura de directoris no est&agrave; creada, la crear&agrave; la mateixa
% funció per poder descomprimir el fitxer.
%
% *PARÀMETRES D'ENTRADA*
%
% * |ID_measure: [string]| -
%      Identificador de la mesura
%
% * |Auth: [structure]| -
%      Variable de tipus estructura amb els valors d'autenticació (Auth) en cadascun dels seus camps:
%
% *Camps de l'estructura:*
%
% - |Auth.GenericU:[string]| - Usuari per a la primera autenticació
%
% - |Auth.GenericP:[string]| - Clau per a la primera autenticació
%
% - |Auth.PersonalU:[string]| - Usuari per a la segona autenticació
%
% - |Auth.PersonalP:[string]| - Clau per a la segona autenticació
%
% * |idType: [double vector]| -
%      Tipus de fitxer que es vol descarregar. Pot ser de tipus 'ELDA' o tipus 'ELPP'.
%
% *VALORS DE RETORN*
%
% * |ErrorType[int]| -
%      Torna 0 si es descarrega el fitxer correctament i -1 en cas
%      de produir-se algun error.
%
% * |ErrorMessage[String]| -
%      Torna una descripció amb el resultat de la baixada.
%
% * |ID_measure[String]| -
%       Identificador de la mesura.
