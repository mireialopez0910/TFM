%% grasp_plotting_UPC_D1P_L(path2file, Lambda,Waves_AERONET2,size_binsF,size_binsC)
%
%% Descripció
%
% Realitza els c&agrave;lculs necessaris per a representar gr&agrave;ficament els productes derivats del GRASP.
% Concretament, aquesta versió és responsable de la configuració D1P_L (Lidar sense informació de polarització i fotòmetre amb informació de polarització).
%
% *PARÀMETRES D'ENTRADA*
%
% * |path2file: [string]| -
%      El camí on els fitxers necessaris per a realitzar els c&agrave;lculs i representar-los gr&agrave;ficament es localitzen.
%
% * |Lambda: [double vector]| -
%      Totes les longituds d'ona de la radiació d'incidència utilitzades dins del GRASP.
%      Entrades (355, 380, 440, 500, 532, 675, 870, 1020, 1064, 1640).
%
% * |Waves_AERONET2: [double vector]| -
%      Totes les longituds d'ona del fotòmetre AERONET utilitzades dins les entrades del GRASP.
%      Entrades (380, 440, 500, 675, 870, 1020, 1640).
%
% * |size_binsF: [double vector]| -
%      Intervals de distribució de la grand&agrave;ria de les partícules petites.
%
% * |size_binsC: [double vector]| -
%      Intervals de distribució de la grand&agrave;ria de les partícules grans.
%
%
% *VALORS DE RETORN*
%
% * |[int]| - Retorna |0| si no es troben els fitxers OUT o GRASP i |1| si el procés de c&agrave;lcul i dibuix és correcte
%
%% Preparació de dades
%
% * Perfils verticals d'aerosol. Es van multiplicar per 1000.
%
% * Distribució de la mida del volum
%
% * AAOD
%
% * SSA
%
% * AOD
%
% * Relació Lidar
%
% * Índex de refracció imagin&agrave;ria (reff_index_imag)
%
% * Estimació del índex de refracció imaginaria (reff_index_imag)
%
% * Índex de refracció real
%
% * Estimació del índex de refracció real (reff_index_real)
%
% * Soroll residual, relatiu i absolut
%
% * Perfils d'extinció i retrodispersió a 355 nm, 532 nm i 1064 nm, respectivament.
%
% * Perfil d'absorció d'aerosols a 355 nm, 532 nm i 1064 nm, respectivament.
%
% * Perfils SSA
%
% * Perfils de relació Lidar
%
% * Perfils Angstrom
%
% * Fracció de l'esfera
%
%% Traça
%
% * Perfils verticals de aerosol
%
% * VSD (GRASP x AERONET)
%
% * IRI (GRASP x AERONET)
%
% * RRI (GRASP x AERONET)
%
% * AAOD (GRASP x AERONET)
%
% * SSA (GRASP x AERONET)
%
% * AOD (GRASP x AERONET)
%
% * LR (GRASP x AERONET)
%
% * Perfils d'extinció
%
% * Perfils de retrodispersió d'aerosols
%
% * Perfils d'absorció d'aerosols
%
% * Perfils SSA
%
% * Perfils LR
%
% * Perfils Angstrom
%
% * Retrodispersió (GRASP x SCC)
%
% * VSD
%
% * IRI
%
% * RRI
%
% * AAOD
%
% * SSA
%
% * AOD
%
