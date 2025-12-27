%% foundFiles = read_NetCDF(measureID)
%
%% Descripció
%
% Donada un MeasureID, cerca els arxius de tipus '.nc' (Network Common Data Form)
% les dades del qual facin referència a ELDA i continguin informació sobre les longituds d'ona 1064, 532, 355
%
% *Camps ELDA*
%
% * measurement_start_datetime
% * measurement_stop_datetime
% * wavelength
% * altitude
% * input_file
% * backscatter
% * error_backscatter
% * extinction
% * error_extinction
% * volumedepolarization
% Usant el 'filename' de referència cerca el fitxer ELPP i extreu-ne els
% camps necessaris.
%
% *Camps ELPP*
%
% * measurement_start_datetime
% * measurement_stop_datetime
% * altitude
% * range
% * polarization_channel_geometry
% * range_corrected_signal
%
% Llegeix el flag de polarization_channel_geometry i determina el tipus de canal
% basat en el flag:
%
% Afegeix atributs addicionals com el color per a cada longitud d'ona:
%
% * 1064 red
% * 532  green
% * 355  blue
%
% *Acciones adicionales*
%
% Crea un nom basat en la mesura seleccionada per desar-lo com
% taula a l'espai de treball i se l'assigna a la taula de registre de
% noms per poder recuperar-lo més endavant si cal.
%
% *PARÀMETRES D'ENTRADA*
%
% * |subfolderName: [string]| -
%      URL a la carpeta de fitxers .nc (Network Common Data Form)
%
% *VALORS DE RETORN*
%
% * |foundFiles: [int]| -
%      Nombre de fitxers trobats que s'han processat
%
