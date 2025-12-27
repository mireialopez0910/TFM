%% [GARRLiC_file_name, errorVolumePolarization] = sendData_D1P_L_VD( measureID, heightMin, heightMax, isFigure, isExportLidarData )
%% *DESCRIPCIÓ*
%
% Recull i prepara el conjunt de dades necess&agrave;ries per a la configuració
% de la mesura que inclou dades amb despolarització del LIDAR i dades amb
% polarització del fotòmetre perquè la funció WriteFiles_preGARRLiC_D1P_L_VD()
% pugui crear el fitxer de sortida (*.sdat) que ser&agrave; processat pel GRASP.
%
%
% *PARÀMETRES D'ENTRADA*
%
% * |measureID: [string]| -
%      Identificador de la mesura per a la qual es recogeran les dades (*.nc).
%
% * |heightMin: [int]| -
%      Altura mínima des de la qual es processaran les dades.
%
% * |heightMax: [int]| -
%      Altura m&agrave;xima des de la qual es processaran les dades.
%
% * |isFigure: [True|False]| -
%      Indica si es desitja dibuixar les diferents gr&agrave;fiques durant la
%      recollida de dades. Aquesta funcionalitat és especialment útil per a
%      identificar anomalias en la recollida de dades.
%
% * |isExportLidarData: [True|False]| -
%      Li indica a la funció si desitja incloure en la sortida lor fitxers
%      (*.nc) utilitzats en l'extracció de dades.
%
%
% *VALORS RETORNATS*
%
% * |[GARRLiC_file_name]| -
%      Nom del fitxer escrit després de processar tots les dades
%
%% Directori de sortida
% Crea l'estructura de directoris on es crearan els fitxers per a enviar a GRASP. El nom assignat es definir&agrave; en funció de la configuració seleccionada, la mesura i afegeix un sufix addicional que indica les altures mínima i m&agrave;xima entre les quals s'han realitzat els c&agrave;lculs.
%
% Si els directoris no existeixen es creen però si existeixen no es realitza
% cap acció per a evitar sobreescriure els existents.
%
% Identifica el nom de la taula ELDA-ELPP per a carregar-la des del workspace
%% Dades LIDAR
% Cerca les dades ELDA i ELPP disponibles en diferents longituds d'ona 355*, 532* i 1064*
%
% * |'altitude'|
% * |'total_power_*channel'|
% * |'start_*datetime'| data i hora de l'inici de la mesura
% * |'stop_datetime'| data i hora de finalització de la mesura
%% Datetime
% La data i hora de presa de dades usa format format ISO 8601.
% Per a assignar el nom al fitxer usa el format: 'yyyymmddHHMMSS'
% Convertir datetime a cadena
%% GRASP Range
% Generar vector espaiat logarítmicament de 60 punts entre la
% altura mínima i m&agrave;xima que s'usa per a interpolar linealment els
% rangs i RCS de les diferents longituds d'ona.
%% Generació 'GRASP_[ubicació]_'
% Les dades obtingudes anteriorment són emmagatzemats en un fitxer
% al qual se li van afegint més informació progressivament
%
%% Perfil ELDA
% Afegeix les dades referents al perfil Elda per a les diferents longituds d'ona disponibles:
% 1064 / 532 / 355 (altitude, backscatter) i es guarden en el fitxer GRASP_BRC.
%
% Nota: Aquesta part s'ha mogut des de 'elda_profile.m per motius de
% unificació de dades en el fitxer GRASP_BRC
%
% *Dades a recuperar:*
%
% * |elda_altitude| - dades d'altitud del fitxer Elda.
% * |backscatter| - dades de backscatter del fitxer Elda
%% CIMEL
% Llegeix les mesures AOD (Aerosol Optical Depth) del fotòmetre CIMEL
% (tfLev15_1) usant els filtres previs de data/hora d'inici i fi.
% Si no coincideix el rang filtrat buscar&agrave; les coincidències més
% pròximes
%
% Addicionalment afegir&agrave;:
%
% * informació de l'Àngstrom Exponent (440-870 nm)
%
% * Latitud, longitud i dia del any
%
% * Angle del zenit solar i les radi&agrave;ncies (uW/cm²/Sr\nm)
%
% * Angle del zenit per a cada longitud d'ona
%
% * Les radi&agrave;ncies per a cada longitud d'ona
%
% Revisa la simetria de les mesures Almucantar i filtra les
% radi&agrave;ncies no v&agrave;lides eliminant aquelles inferiors al 20%
%
% Converteix les radi&agrave;ncies absolutes a normalitzades (radi&agrave;ncies
% reduïdes), calcula l'angle per al dia de l'any i la dist&agrave;ncia
% de la Terra al Sol
%
% *Nota addicional:* Extraterrestrial irradiance [Wavelength (nm) and Irradiance W/(m² nm)] "Synthetic/compòsit Extraterrestrial Spectrum by Chris Gueymard, May 2003"
% 380->1.0960, 440->1.848, 500->1.9320, 675->1.492, 870->0.9894, 1020->0.6972, 1640->0.2212
% Radiance normalized. From uW/cm² to mW/m², multiply by 10. Irradiance values for GRASP: 1.0000E-11 - 1.0000E+02
%% AERONET
% Afegeix les dades de AERONET (*.all) per a comparar-los amb GRASP
%
% * Índex de refracció
%
% * Albedo de Dispersió Única (SSA)
%
% * Distribució de la Grand&agrave;ria de Volum (VSD)
%
% * Profunditat Òptica d'Aerosols d'Absorció (AAOD)
%
% * Factor d'Esfericitat
%
% * Concentració en Volum i radi efectiu (VC, ER)
%
% * R&agrave;tio Lidar (LR)
%
% * Grau de polarització de l'angle azimut en graus des d'AERONET
%
% * DOLP des d'AERONET
%
% Realitza una prova de simetria
%
%% Escriptura preGARRLiC
% Una vegada recollit totes les dades s'envien a la funció
% |WriteFiles_preGARRLiC_D1P_L_VD(...)| encarregada d'escriure el fitxer
% de sortida SDAT. Si s'escriu correctament retornar&agrave; el nom
% de l'arxiu creat.
