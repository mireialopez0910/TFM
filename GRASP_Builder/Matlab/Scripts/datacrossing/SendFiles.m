configFile = 'config_preview.txt';

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
URL_aeronet = Folder_AERONET

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

    fid = fopen('sendFiles_output.txt','w');

    fprintf(fid, 'heightLimitMin = %s\n', num2str(heightLimitMin));
    fprintf(fid, 'heightLimitMax = %s\n', num2str(heightLimitMax));

    

    %
    % Get all filtered data
    [tfLev15_1, cont_lev15_1] = getFilteredTable('lev15', 1);
    % [tfLev15_2, cont_lev15_2] = getFilteredTable('lev15', 2); # for lunar version
    [tfAlm, cont_alm] = getFilteredTable('alm', 1);
    [tfAlp, cont_alp] = getFilteredTable('alp', 1);
    [tfAll, cont_all] = getFilteredTable('all', 1);
    [tfElda, cont_elda] = getFilteredTable('elda', 1);

    %
    % Assign filtered data to Workspace tables
    assignin('base', 'tfLev15_1', tfLev15_1);
    % assignin('base', 'tfLev15_2', tfLev15_2); # for lunar version
    assignin('base', 'tfAlm', tfAlm);
    assignin('base', 'tfAlp', tfAlp);
    assignin('base', 'tfAll', tfAll);
    assignin('base', 'tfElda', tfElda);

    % Check if ALM & AOD have info in the filtered table

    logMessage(['T-AOD:', num2str(cont_lev15_1)])
    logMessage(['T-ALM:', num2str(cont_alm)])


    if(str2double(cont_lev15_1) == 0 || str2double(cont_alm) == 0 || str2double(cont_all) == 0)
        logMessage('Your filter hasn''t any result for AOD / ALM / ALL tables. Try to select other range of dates | Data not found for your filter');
    end


    % Devuelve las configuraciones disponibles
    [is_D1_L, is_D1P_L, is_D1_L_VD, is_D1P_L_VD, messageFromCheckSendData] = checkSendDataConfigs();

    if strcmpi(strtrim(is_D1_L), "true")
        logMessage('D1_L enabled');
        fprintf(fid, 'D1_L=enabled\n');
    else
        logMessage('D1_L disabled');
        fprintf(fid, 'D1_L=disabled');
    end

    if strcmpi(strtrim(is_D1P_L), "true")
        logMessage('D1P_L enabled');
        fprintf(fid, 'D1P_L=enabled\n');
    else
        logMessage('D1P_L disabled');
        fprintf(fid, 'D1P_L=disabled\n');
    end

    if strcmpi(strtrim(is_D1_L_VD), "true")
        logMessage('D1_L_VD enabled');
        fprintf(fid, 'D1_L_VD=enabled\n');
    else
        fprintf(fid, 'D1_L_VD=disabled\n');
        logMessage('D1_L_VD disabled');
    end                    

    if strcmpi(strtrim(is_D1P_L_VD), "true")
        logMessage('D1P_L_VD enabled');
        fprintf(fid, 'D1P_L_VD=enabled\n');
    else
        fprintf(fid, 'D1P_L_VD=disabled\n');
        logMessage('D1P_L_VD disabled');
    end

end

%%%%  ACCEPT PUSHED %%%%


%%%%  PLOT DATA PUSHED %%%%
if strcmpi(strtrim(preview), "true")
    
    plotter(heightLimitMin,heightLimitMax,plot_ELPP);
end
%%%%  PLOT DATA PUSHED %%%%


%%%%  SEND PUSHED %%%%
if strcmpi(strtrim(sendData), "true")
    % cfgSelected = 'D1_L: Photometer + lidar' 
    GARRLiC_file_name = '';
    errorVolumePolarization = false;
    
    if strcmpi(strtrim(is_D1P_L_VD_checked), "true")
        [GARRLiC_file_name, errorVolumePolarization] = sendData_D1P_L_VD(selected_measure_ID, hMin, hMax, 0, 0);
        fid = fopen('sendFiles_output.txt','w');
        fprintf(fid, 'selected_config = D1P_L_VD\n');
        fclose(fid);
    end
    if strcmpi(strtrim(is_D1P_L_checked), "true")
        GARRLiC_file_name = sendData_D1P_L(selected_measure_ID, hMin, hMax, 0, 0);
        fprintf(fid, 'selected_config = D1P_L\n');
    end
    if strcmpi(strtrim(is_D1_L_VD_checked), "true")
        [GARRLiC_file_name, errorVolumePolarization] = sendData_D1_L_VD(selected_measure_ID, hMin, hMax, 0, 0);
        fprintf(fid, 'selected_config = D1_L_VD\n');
    end
    if strcmpi(strtrim(is_D1_L_checked), "true")
        GARRLiC_file_name = sendData_D1_L(selected_measure_ID, hMin, hMax, 0, 0);
        fprintf(fid, 'selected_config = D1_L\n');
    end
    
    if ~isempty(GARRLiC_file_name)
        logMessage( ['GARRLiC: output file ', GARRLiC_file_name, ' written correctly']);
        fid = fopen('sendFiles_output.txt','w');
        fprintf(fid, 'GARRLiC_file_name = %s\n', GARRLiC_file_name);
        fclose(fid);
    else
        logMessage('GARRLiC: error writing the output file');
        if(errorVolumePolarization)
            logMessage('----- Affected fields: VD355, VD532, RangeVD355, RangeVD532 || Please check LIDAR Volume Polarization avaliability in ''008'' files || ERROR: Volume Polarization missing data');
        end
    end
end
%%%%  SEND PUSHED %%%%


function [minELPPAltitude, maxELPPAltitude, minVDAltitude, maxVDAltitude] = getValidEldaAltitude()

    minELPPAltitude =''; 
    maxELPPAltitude =''; 
    minVDAltitude ='';
    maxVDAltitude ='';

    [tfElda, cont_elda] = getFilteredTable('elda', 1);

    minELPPAltitude = [min(cell2mat( tfElda(1,:).elpp_altitude))];
    maxELPPAltitude = [max(cell2mat( tfElda(1,:).elpp_altitude))];

    minAltitudeCandidates = minELPPAltitude;
    maxAltitudeCandidates = maxELPPAltitude;

    for k=1 : height(tfElda)
        VolDep = tfElda.volumedepolarization{k};
      
        if isnan(VolDep)
            logMessage('Volume Depolarizaton not found... Ignoring Elda altitude')
        else
            numericArray = cell2mat(cellfun(@(x) x(:), tfElda.elda_altitude(k,1), 'UniformOutput', false));
    
            minAltitudeCandidates = [minAltitudeCandidates, min(numericArray(:))];
            maxAltitudeCandidates = [maxAltitudeCandidates, max(numericArray(:))];
            
            logMessage(['Min. height for VD ', num2str(tfElda.wavelength(k,1)), ' is ', num2str(min(numericArray(:)))]);
            logMessage(['Max. height for VD ', num2str(tfElda.wavelength(k,1)), ' is ', num2str(max(numericArray(:)))]);     

            minVDAltitude = max(minAltitudeCandidates);
            maxVDAltitude = min(maxAltitudeCandidates);
        end
    end
end

function results = plotter(heightLimitMin,heightLimitMax,plot_ELPP)
    %% Magnification factors
    VDmagFactor  = 1;
    TPCmagFactor = 1000000;
    
    aLegends = {};
    
    VDhasNaNMessage  = [];
    VDhasNaNCount    = 0;
    TPChasNaNMessage = [];
    TPChasNaNCount   = 0;
    
    %% ======= GET DATA =======
    [tfElda, cont_elda] = getFilteredTable('elda', 1);
    
    %% ======= Create axes =======
    figure;
    ax = axes;
    cla(ax); hold(ax, "on");
    
    
    if strcmpi(strtrim(plot_ELPP), "true")
        %% ===========================
        %     ELPP – Total Power Channel
        % ===========================
        
        for k = 1:height(tfElda)
        
            currentTPC = cell2mat(tfElda(k,:).total_power_channel);
        
            if isnan(currentTPC)
                logMessage(['No Total Power Channel data at ', num2str(tfElda(k,:).wavelength)]);
                continue;
            else
            
                cTPCElppAltitude = cell2mat(tfElda(k,:).elpp_altitude);
                cTPCElppValue    = cell2mat(tfElda(k,:).total_power_channel);
            
                % Range filter
                idx = cTPCElppAltitude > heightLimitMin & cTPCElppAltitude < heightLimitMax;
                cTPCElppAltitude = cTPCElppAltitude(idx);
                cTPCElppValue    = cTPCElppValue(idx);
            
                % Amplify 1064 nm
                if strcmpi(num2str(floor(tfElda(k,:).wavelength)),'1064')
                    cTPCElppValue = cTPCElppValue * TPCmagFactor;
                end
            
                % Plot TPC
                plot(ax, cTPCElppValue, cTPCElppAltitude, "Color", tfElda.attr_color{k});
                aLegends{end+1} = ['TotalPowerChannel', num2str(tfElda(k,:).wavelength)];
            
                % Check NaNs
                if any(isnan(cTPCElppValue))
                    TPChasNaNCount = TPChasNaNCount + 1;
                    TPChasNaNMessage = [TPChasNaNMessage, num2str(tfElda(k,:).wavelength), ' '];
                end
            end
        end
    else
        %% ===========================
        %     ELDA – Volume Depolarization
        % ===========================
        
        vdLineColor = 'black';
        vdCount = 0;
        
        for k = 1:height(tfElda)
        
            currentVD = cell2mat(tfElda(k,:).volumedepolarization);
        
            if isnan(currentVD)
                logMessage(['No VD data at wavelength ', num2str(tfElda(k,:).wavelength)]);
                continue;
            else
        
	            % alternate color for subsequent curves
	            if vdCount > 0
	                vdLineColor = 'magenta';
	            end
        
	            cVDEldaAltitude = cell2mat(tfElda(k,:).elda_altitude);
	            cVDEldaValue    = cell2mat(tfElda(k,:).volumedepolarization);
        
	            % Range filter
	            idx = cVDEldaAltitude > heightLimitMin & cVDEldaAltitude < heightLimitMax;
	            cVDEldaAltitude = cVDEldaAltitude(idx);
	            cVDEldaValue    = cVDEldaValue(idx);
        
	            % Plot VD
	            plot(ax, cVDEldaValue * VDmagFactor, cVDEldaAltitude, "Color", vdLineColor);
	            aLegends{end+1} = ['VD', num2str(tfElda(k,:).wavelength)];
        
	            % Check NaNs
	            if any(isnan(cVDEldaValue))
	                VDhasNaNCount = VDhasNaNCount + 1;
	                VDhasNaNMessage = [VDhasNaNMessage, num2str(tfElda(k,:).wavelength), ' '];
	            end
        
	            vdCount = vdCount + 1;
	        end
        end
    end

    %% ======= LABELS, LEGEND =======
    if strcmpi(strtrim(plot_ELPP), "true")
        xlabel(ax, "Range corrected signal");
    else
        xlabel(ax, "VD signal");
    end
    
    ylabel(ax, "Altitude");
    legend(ax, aLegends);
    grid(ax, "on");
    
    drawnow;
    
    %% ======= ERROR MESSAGES =======
    
    if VDhasNaNCount > 0
        logMessage(['WARNING', 'Selected range contains NaNs in VD at wavelengths: ', VDhasNaNMessage]);
    end
    
    if TPChasNaNCount > 0
        logMessage(['WARNING', 'Selected range contains NaNs in TPC at wavelengths: ', TPChasNaNMessage]);
    end
    
    logMessage("VD NaN count: " + VDhasNaNCount);
    logMessage("TPC NaN count: " + TPChasNaNCount);
    waitfor(gcf);
end
    