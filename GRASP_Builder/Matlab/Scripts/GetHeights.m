configFile = 'config_scripts.txt';

%%%% LOAD RESOURCES %%%%
warning('off','all');

hMax=0;
hMin=0;
run('config_file.m');
read_configuration;
heightLimitMin = 0;
heightLimitMax = 1200;

tWorkSpaceNames = table('Size', [0, 3], ...
    'VariableTypes', {'char', 'char', 'char'}, ...
    'VariableNames', {'table_name', 'type', 'location'});

assignin('base', 'WSTNames' , tWorkSpaceNames)

currentFolder = fileparts(mfilename('fullpath'));
URL_aeronet = Folder_AERONET;

logMessage('RESOURCES: reading ''AOD'' files')
foundFilesAOD = read_Aeronet( URL_aeronet );

logMessage('RESOURCES: reading ''ALM'' files');
foundFilesAlm = read_Alm( URL_aeronet );

logMessage('RESOURCES: reading ''ALL'' files');
foundFilesAll = read_All( URL_aeronet );

logMessage('RESOURCES: reading ''ALP'' files');
foundFilesAlp = read_Alp( URL_aeronet );

%%%%  ACCEPT PUSHED %%%%

currentFile = mfilename('fullpath'); % Obtiene la ruta completa del archivo actual
rootFolder = fileparts(currentFile); % Subir un nivel en el directorio

addpath( fullfile(rootFolder, 'tools') );

% Limpia las tablas previas ELDA
clearWSTNByType('elda');

foundFilesELDA = read_NetCDF(selected_measure_ID,Folder_LIDAR);

logMessage(['foundFilesNetCDF: ', num2str(foundFilesELDA)]);


%Busca el nombre de la tabla Elda para cargarla
tEldaElpp = [];
filterBRC_008 = ''; 

elda_name = getWSTNByType('elda').table_name;
if ~isempty(elda_name)
    tEldaElpp = evalin('base', elda_name{1});
end

%tEldaElppFilteredByBRC_008 = tEldaElpp(filterBRC_008, :);
    
%%Control de que hay demasiados archivos

if foundFilesELDA > 0
    [statusWaveLength, message_wavelength, status_1064, message_1064, status_0532, message_0532, status_0355, message_0355] = checkElda(); 
end

if (foundFilesAOD > 2) || (foundFilesAlm > 1) || (foundFilesAll > 1)
    logMessage('ERROR: Use one AOD and ALM. If you are using optional ALP or ALL files, ensure that you are using one only in your repository.');
    logMessage('ERROR: Use one AOD and ALM. If you are using optional ALP or ALL files, ensure that you are using one only in your repository.');

elseif (foundFilesAOD == 0) || (foundFilesAlm == 0)
    logMessage('ERROR: AOD or ALM files can''t be found in the repository.');

elseif foundFilesELDA == 0
    logMessage('ERROR: ELDA file missing or invalid. Check files in the repository.');

elseif statusWaveLength ~=1

    logMessage( ['ERROR: ', message_wavelength]);
    logMessage( ['ERROR: ', message_1064]);
    logMessage( ['ERROR: ', message_0532]);
    logMessage( ['ERROR: ', message_0355]);

else

    logMessage( ['ELDA/ELPP: ', message_wavelength]);

    %%% Get Elda Atitude limits and assign to GUI
    [heightELPPLimitMin, heightELPPLimitMax, heightVDLimitMin, heightVDLimitMax] = getValidEldaAltitude();
    

    heightLimitMin = min(cell2mat( tEldaElpp(1,:).elpp_altitude));
    heightLimitMax = max(cell2mat( tEldaElpp(1,:).elpp_altitude));
    
    if hMin ~= 0
        heightLimitMin = hMin;
    end

    if hMax ~= 0
        heightLimitMax = hMax;
    end

    fid = fopen('scripts_output.txt','a');

    fprintf(fid, 'heightLimitMin = %s\n', num2str(heightLimitMin));
    fprintf(fid, 'heightLimitMax = %s\n', num2str(heightLimitMax));
    logMessage("Height values saved in output file:")
    logMessage("heightLimitMin: "+ num2str(heightLimitMin));
    logMessage("heightLimitMax: "+ num2str(heightLimitMax));
    noError = true;


end