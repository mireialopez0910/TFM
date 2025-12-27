%% Magnification factors
VDmagFactor  = 1e11;
TPCmagFactor = 10000;

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

        else
    
	        cTPCElppAltitude = cell2mat(tfElda(k,:).elpp_altitude);
	        cTPCElppValue    = cell2mat(tfElda(k,:).total_power_channel);
    
	        % Range filter
	        idx = cTPCElppAltitude > heightLimitMin & cTPCElppAltitude < heightLimitMax;
	        cTPCElppAltitude = cTPCElppAltitude(idx);
	        cTPCElppValue    = cTPCElppValue(idx);
    
	        % Amplify 1064 nm
	        if tfElda(k,:).wavelength == 1064
	            cTPCElppValue = cTPCElppValue * TPCmagFactor;
	        end
    
	        % Plot TPC
	        plot(ax, cTPCElppValue, cTPCElppAltitude, "Color", tfElda.attr_color{k});
	        aLegends{end+1} = ['RCS', num2str(tfElda(k,:).wavelength)];
    
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
