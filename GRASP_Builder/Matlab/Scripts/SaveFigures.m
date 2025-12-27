%%! Descripción
%!
%! Lanza la petición de ploteo para la medida y configuración
%! seleccionada en los selectores correspondientes de la interfaz.
%1 Previamente identifica el tipo de configuración seleccionada y
% ejecuta la función de ploteo requerida.
%!
%! *PARÁMETROS DE ENTRADA*
%!
%! * |app: [app object]| -
%!      Instancia de la clase de la aplicación que estás creando
%!
%! * |event: [event object]| -
%!      Ejecuta la función cuando se produce el evento asignado. En
%!      este caso la pulsación del botón

%! *VALORES DE SALIDA*
%!
%! * No devuelve ningún valor
%!     
%1
%1 *Nota 1:* Se distinguen en código las diferentes configuraciones
% por motivos de escalabilidad en futuras versiones pero en la
% actual las cuatro configuraciones invocan la misma función de
% ploteo.
%!
%! *Nota 2:* El botón se deshabilita una vez pulsado hasta que finaliza
%! el ploteado de los datos. De esta manera se impide iniciar un nuevo
%! ploteo antes de finalizar el anterior y 
%! el consecuente mensaje de error del sistema.


%Plotting GRASP outputs

% clear all
% clc
%%
%% This part has been moved to SCC Module
%Read ELDA products 
% ElDA_Profiles_Correctly = ELDA_Profiles();
%%
%Write down all wavelengths used in GRASP inputs.
Lambda = [355,380,440,500,532,675,870,1020,1064,1640];
Waves_AERONET2 = [380,440,500,675,870,1020,1640];
%These values are from GRASP to the VSD.
size_binsF = [0.05,0.0656,0.086,0.11294,0.14818,0.19443,0.25511,0.33472,0.43917,0.57623];
size_binsC = [0.33472,0.43917,0.57623,0.75605,0.99199,1.3016,1.7078,2.2407,2.94,3.8575,5.0613,6.6407,8.7131,11.432,15];
% size_bins = [0.05,0.0656,0.086,0.11294,0.14818,0.19443,0.25511,0.33472,0.43917,0.57623,0.75605,0.99199,1.3016,1.7078,2.2407,2.94,3.8575,5.0613,6.6407,8.7131,11.432,15];
%Aerosol volume concentration changes for each case run in GRASP
% AVCF = input('Aerosol volupme concentration - Fine mode: ');
% AVCC = input('Aerosol volume concentration - Coarse mode: ');

configFile = 'config_savefigures.txt';
read_configuration;
currentFolder = fileparts(mfilename('fullpath'));
run('config_file.m');
% parentFolder = fileparts(currentFolder);
measureIDFolder = CONFIG_output

fullPath = fullfile(measureIDFolder, selected_measure_ID, selected_measurement_file_to_show);

if startsWith(selected_measurement_file_to_show, 'D1_L-', 'IgnoreCase', true)
    GRASP_Plot_Correctly = grasp_plotting_UPC(fullPath, 'D1_L', Lambda,Waves_AERONET2,size_binsF,size_binsC);
    logMessage(['OUT or GRASP data file not found for D1_L configuration in measure ', selected_measure_ID]);

elseif startsWith(selected_measurement_file_to_show, 'D1_L_VD-', 'IgnoreCase', true)
    GRASP_Plot_Correctly = grasp_plotting_UPC(fullPath, 'D1_L_VD', Lambda,Waves_AERONET2,size_binsF,size_binsC);
    logMessage(['OUT or GRASP data file not found for D1_L_VD configuration in measure ', selected_measure_ID]);

elseif startsWith(selected_measurement_file_to_show, 'D1P_L-', 'IgnoreCase', true)
    GRASP_Plot_Correctly = grasp_plotting_UPC(fullPath, 'D1P_L', Lambda,Waves_AERONET2,size_binsF,size_binsC);
    logMessage(['OUT or GRASP data file not found for D1P_L configuratio in measure ', selected_measure_ID]);

elseif startsWith(selected_measurement_file_to_show, 'D1P_L_VD-', 'IgnoreCase', true)
    GRASP_Plot_Correctly = grasp_plotting_UPC(fullPath, 'D1P_L_VD', Lambda,Waves_AERONET2,size_binsF,size_binsC);
    logMessage(['OUT or GRASP data file not found for D1P_L_VD configuration in measure ', selected_measure_ID]);

else
    logMessage('Unknown configuration ');
    disp('Unknown configuration ');
end

if(GRASP_Plot_Correctly)
    logMessage(['OUT or GRASP data file not found for your configuration in measure ', selected_measure_ID]);
end