%% [isValid, message] = AuthSCCAccess(Auth)
%% Descripció
%
% Envia les credencials d'accés a la plataforma SCC utilitzant una doble autenticació
% per obtenir un accés v&agrave;lid. La primera autenticació es realitza a nivell de servidor
% i la segona valida l'accés a les p&agrave;gines que requereixen un token de sessió v&agrave;lid.
%
% El par&agrave;metre d'autenticació (Auth) ha de ser de tipus estructura i
% els camps de tipus cadena (Auth.GenericU, Auth.GenericP, Auth.PersonalU, Auth.PersonalP)
%
% *PARÀMETRES D'ENTRADA*
%
% * |Auth: [structure]| -
%      variable de tipus estructura amb els valors d'autenticació (Auth) en cadascun dels seus camps:
%
% *Camps de l'estructura:*
%
% * |Auth.GenericU:[string]| - Usuari per a la primera autenticació
% * |Auth.GenericP:[string]| - Clau per a la primera autenticació
% * |Auth.PersonalU:[string]| - Usuari per a la segona autenticació
% * |Auth.PersonalP:[string]| - Clau per a la segona autenticació
%
% *VALORS DE RETORN*
%
% |[isValid, message]|
%
% * |isValid:[boolean]| -
%      Retorna |true| si les credencials d'autenticació són correctes i |false| en cas contrari.
%
% * |message:[string]| -
%      Missatge explicatiu sobre l'estat de l'autenticació.
%
