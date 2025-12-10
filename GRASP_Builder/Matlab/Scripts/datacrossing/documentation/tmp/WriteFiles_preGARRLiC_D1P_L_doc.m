%% [GARRLiC_file_name] = WriteFiles_preGARRLiC_D1P_L(measureID, outPath, latitude, longitude, ground_height, SZA380, SZA440, SZA500, SZA675, SZA870, SZA1020, SZA1640, SAA380, SAA440, SAA500, SAA675, SAA870, SAA1020, SAA1640, AOD380, Radiancia380, AOD440, Radiancia440, AOD500, Radiancia500, AOD675, Radiancia675, AOD870, Radiancia870, AOD1020, Radiancia1020, AOD1640, Radiancia1640, PAA1640, mPol1640, PAA1020, mPol1020, PAA870, mPol870, PAA675, mPol675, PAA500, mPol500, PAA440, mPol440, PAA380, mPol380, RangeIni, LS355, LS532, LS1064, NombreEntrada1, NombreEntrada2)
%% DESCRIPCIÓ
%
% Aquesta funció prepara el fitxer 'SDATA' per a la inversió garrlic amb
% l'AOD (7λ) + irradiances + grau de polarització + 3 RCS de lidar para la
% configuració de LIDAR sense informació de la despolarització de volum y del fotómetre
% sense informació de polarització.
%
% *PARÀMETRES D'ENTRADA*
%
% * measureID - Identificador de la mesura.
% * outPath - Ruta de l'arxiu.
% * latitude - Latitud de la presa de mesures.
% * longitude - Latitud de la presa de mesures.
% * ground_height - Alçada des del terra.
% * SZA380 - Angle del zenit solar per a la longitud de l'ona de 380 nm
% * SZA440 - Angle del zenit solar per a la longitud de l'ona de 440 nm
% * SZA500 - Angle del zenit solar per a la longitud d'ona de 500 nm
% * SZA675 - Angle del zenit solar per a la longitud de l'ona de 675 nm
% * SZA870 - Angle del zenit solar per a la longitud de l'ona de 870 nm
% * SZA1020 - Angle del zenit solar per a la longitud de l'ona de 1020 nm
% * SZA1640 - Angle del zenit solar per a la longitud de l'ona de 1640 nm
% * SAA380 - Angle azimut solar per a la longitud de l'ona de 380 nm
% * SAA440 - Angle azimut solar per a la longitud de l'ona de 440 nm
% * SAA500 - Angle azimut solar per a la longitud de l'ona de 500 nm
% * SAA675 - Angle azimut solar per a la longitud de l'ona de 675 nm
% * SAA870 - Angle azimut solar per a la longitud de l'ona de 870 nm
% * SAA1020 - Angle azimut solar per a la longitud de l'ona de 1020 nm
% * SAA1640 - Angle azimut solar per a la longitud de l'ona de 1640 nm
% * AOD380 - Profunditat òptica de l'aerosol per a la longitud d'ona de 380 nm
% * Radiancia380 - Radi&agrave;ncia per a la longitud d'ona de 380 nm
% * AOD440 - Profunditat òptica de l'aerosol per a la longitud d'ona de 440 nm
% * Radiancia440 - Radi&agrave;ncia per a la longitud d'ona de 440 nm
% * AOD500 - Profunditat òptica de l'aerosol per a la longitud d'ona de 500 nm
% * Radiancia500 - Radi&agrave;ncia per a la longitud d'ona de 500 nm
% * AOD675 - Profunditat òptica de l'aerosol per a la longitud de l'ona de 675 nm
% * Radiancia675 - Radi&agrave;ncia per a la longitud d'ona de 675 nm
% * AOD870 - Profunditat òptica de l'aerosol per a la longitud d'ona de 870 nm
% * Radiancia870 - Radi&agrave;ncia per a la longitud d'ona de 870 nm
% * AOD1020 - Profunditat òptica de l'aerosol per a la longitud de l'ona de 1020 nm
% * Radiancia1020 - Radi&agrave;ncia per a la longitud d'ona de 1020 nm
% * AOD1640 - Profunditat òptica de l'aerosol per a la longitud de l'ona de 1640 nm
% * Radiancia1640 - Radi&agrave;ncia per a la longitud d'ona de 1640 nm
% * PAA1640 - angle azimutal principal a 640 nm
% * mPol1640 - magnitud de la polarización a 1640 nm
% * PAA1020 - angle azimutal principal a 1020
% * mPol1020 - magnitud de la polarització a 1020 nm
% * PAA870 - angle azimutal principal a 870
% * mPol870 - - magnitud de la polarització a 870 nm
% * PAA675 - angle azimutal principal a 675
% * mPol675 - magnitud de la polarització a 675 nm
% * PAA500 - angle azimutal principal a 500
% * mPol500 - magnitud de la polarització a 500 nm
% * PAA440 - angle azimutal principal a 440
% * mPol440 - magnitud de la polarització a 440 nm
% * PAA380 - angle azimutal principal a 380
% * mPol380 - magnitud de la polarització a 1360 nm
% * RangeIni - Rang inicial de dist&agrave;ncia del perfil LIDAR.
% * LS355 - senyal lidar a 355 nm
% * LS532 - senyal lidar a 532 nm
% * LS1064 - senyal lidar a 1064 nm
% * NombreEntrada1 - Nom afegit al contingut del fitxer GARRLIC
% * NombreEntrada2 - Nom usat per construir el nom de l'arxiu GARRLIC%
%
% *VALORS DE RETORN*
%
% * |GARRLiC_file_name: [string]| -
%      Retorna un array de cel·les que contenen cadascuna, un missatge
%      concret sobre el resultat de les revisions pertinents de les dades.
%
