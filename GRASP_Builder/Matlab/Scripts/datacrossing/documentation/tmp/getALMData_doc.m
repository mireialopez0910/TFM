%% [isValid, message] = getALMData()
%% DESCRIPCIÓ
%
% Analitza les dades de la taula ALM i comprova que hi hagi dades a 'Nominal_Wavelength(nm)' per a les
% longituds d'ona: 1640, 1020, 870, 675, 500, 440, 380
%
% *PARÀMETRES D'ENTRADA*
%
% * No es requereixen par&agrave;metres d'entrada
%
%
% *VALORS DE RETORN*
%
% * |isValid: [boolean]| -
%      Torna 'true' si conté totes les dades requerides per poder aplicar
%      la configuració i en cas de contrari retorna un 'false'
%
% * |message: [cell[string]]| -
%      Retorna un array de cel·les que contenen cadascuna, un missatge
%      concret sobre el resultat de les revisions pertinents de les dades.
%
