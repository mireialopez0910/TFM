%% config_file.m (Fitxer de configuració)
%% DESCRIPCIÓ
%
% Fitxer de configuració de l'aplicació que conté una sèrie de
% variables d'inicialització i funcionament en general:
%
% *VARIABLES DE CONFIGURACIÓ SCC*
%
% *Autenticació general*
%
% * |CONFIG_GenericU| -
% Usuari de l'autenticació general a SCC
%
% * |CONFIG_GenericP| -
% Clau de l'autenticació general a SCC
%
% *Autenticació personal*
%
% * |CONFIG_PersonalU| -
% Usuari de l'autenticació personal a SCC
%
% * |CONFIG_PersonalP| -
% Clau de l'autenticació personal a SCC
%
% *URL d'accés al SCC*
%
% * |CONFIG_SCCDomain[String]:| -
% Domini web de Single Calculus Chain (SCC).
% Preconfigurat com a: |https://scc.imaa.cnr.it/|
%
% * |URLdownload_1| -
% URL completa (amb domini) a la p&agrave;gina de mesures del SCC.
% Preconfigurat com a: |https://scc.imaa.cnr.it/data_processing/measurements/|
%
% * |URLdownload_2ELDA| -
% URL per a les desc&agrave;rregues (òptica data) sense incloure el domini.
% Preconfigurat com: |/download-optical/|
%
% |URLdownload_2ELPP| -
% URL per a les desc&agrave;rregues (preprocessed data) sense incloure el domini: |/download-preprocessed/|
%
%
%
%
% *VARIABLES DE CONFIGURACIÓ DE MESURES*
%
% * |CONFIG_folder_SCC| -
% Ruta a l'arbre de directoris local on es troba la configuració de mesures.
% Preconfigurat com a: |config|
%
% * |CONFIG_config_SCC| -
% Nom del fitxer de configuració de mesures.
% Preconfigurat com a: |configuracions_SCC.xlsx|
%
%
%
%
% *VARIABLES DE CONFIGURACIÓ DEL REPOSITORI*
%
% * |CONFIG_LIDAR_folder| -
% Ruta d'accés a la carpeta on es descarreguen els fitxers LIDAR
% del SCC necessaris per crear les configuracions de mesures a l'aplicació.
% Preconfigurat com a: |/repository/LIDAR/|
%
% * |CONFIG_AERONET_folder| -
% Ruta d'accés a la carpeta on es troben precarregats els fitxers
% d'AERONED necessaris per crear les configuracions de mesures a l'aplicació.
% Preconfigurat com a: |/repository/AERONET/|
%
% * |CONFIG_output| -
% Ruta d'accés a la carpeta de sortida on es generen tots els
% fitxers processats per l'aplicació.
% Preconfigurat com a: |/Output/MeasureID/|
%
%
%
%
% *VARIABLES DE CONFIGURACIÓ DE RUTES*
%
% * |currentFolder| -
% Ruta completa del fitxer .m que s'est&agrave; executant.
%
% * |parentFolder| -
% Extrau el directori pare de currentFolder.
%
%
%
%
% *VARIABLES DE CONFIGURACIÓ DE L'AJUDA*
%
% * |CONFIG_help_root| -
% Ruta a la carpeta on es genera la documentació.
