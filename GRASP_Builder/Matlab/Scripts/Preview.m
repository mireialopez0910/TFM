GetHeights;
if noError == true
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

    if(str2double(cont_lev15_1) == 0)
        logMessage("AOD data not found for selected date range")
        noError = false;
    end

    if(str2double(cont_alm) == 0)
        noError = false;
         logMessage("ALM data not found for selected date range")
    end

    if (str2double(cont_all) == 0)
        logMessage("ALL data not found for selected date range")
    end
    
    % if(str2double(cont_lev15_1) == 0 || str2double(cont_alm) == 0 || str2double(cont_all) == 0)
    %     logMessage('Your filter hasn''t any result for AOD / ALM / ALL tables. Try to select other range of dates | Data not found for your filter');
    % end


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

    if (strcmpi(strtrim(preview), "true") && noError == true)
        plotter(heightLimitMin,heightLimitMax,plot_ELPP);
    end

    if(noError == true)
        fprintf(fid, 'isError=false\n');
    else
        fprintf(fid, 'isError=true\n');
    end

    fclose(fid);
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
                cTPCElppAltitude=cTPCElppAltitude(:,1);
                cTPCElppValue    = cell2mat(tfElda(k,:).total_power_channel);
                
                % Range filter
                idx = cTPCElppAltitude > heightLimitMin & cTPCElppAltitude < heightLimitMax;
                cTPCElppAltitude = cTPCElppAltitude(idx,1);
                cTPCElppValue    = cTPCElppValue(idx);

                % Amplify 1064 nm
                if strcmpi(tfElda(k,:).wavelength,'1064')
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
    