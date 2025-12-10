%% [graspData_filename] = read_data_error(path2file, graspOutFile, graspPreGARRLiC_filename)
%% Descripció
%
% Processa les dades rebudes del GRASP (fitxer de sortida *.out) de manera
% adequada per poder ser utilitzades en les funcions de c&agrave;lcul i ploteig:
%
% * grasp_plotting_UPC_D1_L(...)
%
% * grasp_plotting_UPC_D1_L_VD(...)
%
% * grasp_plotting_UPC_D1P_L(...)
%
% * grasp_plotting_UPC_D1P_L_VD(...)
%
% Les dades, un cop processades, es guarden en un nou fitxer amb la
%
% *Nota:* La reel '_graspPreGARRLiC_filename_' s'obté eliminant el prefix
% 'GRASP_BRC_' i l'extensió '.mat'
%
% *PARÀMETRES D'ENTRADA*
%
% * |path2file: [string]| -
%      Ruta on es troben els fitxers *.txt i *.mat requerits en els
%      següents par&agrave;metres de la funció
%
% * |graspOutFile:[string[]]| -
%      Nom del fitxer de sortida generat per l'aplicació GRASP (ex. 'UPC_D1_L_out.txt')
%
% * |graspPreGARRLiC_filename:[string[]]| -
%      Nom del fitxer MAT generat ('GRASP_BRC_*.mat')
%
% *VALORS DE RETORN*
%
% * |graspData_filename: [string]| -
%      Nom del fitxer generat amb les dades processades
%
