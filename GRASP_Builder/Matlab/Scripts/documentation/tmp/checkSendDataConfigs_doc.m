%% [boolean, boolean, boolean, boolean] = checkSendDataConfigs()
%% DESCRIPCIÓ
%
% Analitza les dades de les taules ELDA, ELPP, ALL, ALM, ALP, LEV15 per
% definir les configuracions v&agrave;lides per a generar els fitxers .SDAT i .MAT que s'han d'enviar a GRASP.
%
% *PARÀMETRES D'ENTRADA*
%
% * No es requereixen par&agrave;metres d'entrada
%
% *VALORS DE RETORN*
%
% [is_D1_L, is_D1P_L, is_D1_L_VD, is_D1P_L_VD]
%
% * |is_D1_L: [boolean]| -
%      indica si la configuració D1_L (dades tant del LIDAR com del fotòmetre
%      sense despolarització) estan disponible.
%
% * |is_D1P_L: [boolean]| -
%      indica si la configuració D1P_L est&agrave; disponible
%      (dades del LIDAR sense despolarització i fotòmetre amb despolarització)
%
% * |is_D1_L_VD: [boolean]| -
%      indica si la configuració D1_L_VD est&agrave; disponible
%      (dades del LIDAR amb despolarització i del fotòmetre sense despolarització)
%
% * |is_D1P_L_VD: [boolean]| -
%      indica si la configuració D1P_L_DVD est&agrave; disponible
%      (dades tant del LIDAR com del fotòmetre amb despolarització)
%
% * |message: [cell[string]]| -
%      Retorna un array de cel·les que contenen cadascuna, un missatge
%      concret sobre el resultat de les revisions pertinents de les dades.
%
%% Com funciona
% Per defecte totes les configuracions estan disponibles per utilitzar i
% després de comprovar cada conjunt de condicions per a cada configuració
% s'actualitza amb «false» si no és adequat.
%
% *Important:* Aquesta funció accedeix a les taules filtrades al Workspace
% i analitza les dades disponibles.
%
%
%% Taules analitzades:
%
% * Taula Elda/Elpp (obté el nom usant la funció |getWSTNByType()| )
%
% * Taula OAD (tfLev15_1)
%
% * Taula 'ALL'
%
% * Taula 'ALM'
%
% * Taula 'ALP'
%
%% Dades mínimes requerides
%
% *Dades en rangs filtrats*:
% Consulta la taula AOD (tfLev15_1) i Almucantar (ALM).
% Si falta una de les dues taules TOTES les configuracions canvien a
% desactivat (estat fals)
%
% *Dades específiques requerides en taules*:
% Addicionalment, es revisen determinades dades que han d'existir a les taules ALM i ALP
% per poder generar el fitxer SDAT en terminades configuracions.
%
% * *getALMData()*
% Comprova que hi hagi dades a 'Nominal_Wavelength(nm)' per a les
% longituds d'ona: 1640, 1020, 870, 675, 500, 440, 380
%
% * *getALPData()*
% Comprova que hi hagi dades a 'Nominal_Wavelength(nm)' per a les
% longituds d'ona: 1020, 870, 675, 500, 440, 380
%
%% Taula 'ALP'
% Comprova les dades de polarització del fotòmetre.
% si la taula 'ALP' no est&agrave; disponible, les configuracions D1P_L i D1P_L_VD es desactivaran
%
%% Taula 'ELDA/ELPP'
% Comprova les dades de la despolarització de volum LIDAR (configuració VD).
% si la taula "ELDA/ELPP" no est&agrave; disponible, les configuracions D1_L_VD i D1P_L_VD es desactivaran
%
