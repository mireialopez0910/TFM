
altMin = app.HeightminSpinner.Value;
altMax = app.HeightmaxSpinner.Value;
VDmagFactor = 10^11;
TPCmagFactor = 10000;
aLegends = {};

VDhasNaNMessage = [];
VDhasNaNCount = 0;
TPChasNaNMessage = [];
TPChasNaNCount = 0;

[tfElda, cont_elda] = getFilteredTable('elda', 1);

app.UIAxes.reset;
cla(app.UIAxes);

%% Extracting ELDA VD info
vdLineColor = 'black';
vdCount = 0;
for k=1:height(tfElda)
    currentVD = cell2mat(tfElda(k,:).volumedepolarization);
    if isnan(currentVD)
        disp(['No hay datos de depolización en la longitud de onda ', num2str(tfElda(k,:).wavelength)]);
    else
        
        if(vdCount > 0) 
            vdLineColor = 'magenta';
        end

        cVDEldaAltitude = cell2mat(tfElda(k,:).elda_altitude);
        cVDEldaValue = cell2mat(tfElda(k,:).volumedepolarization);

        idx = find(cVDEldaAltitude > altMin & cVDEldaAltitude < altMax);
        cVDEldaAltitude = cVDEldaAltitude(idx);
        cVDEldaValue = cVDEldaValue(idx);
        plot(app.UIAxes, cVDEldaValue * VDmagFactor, cVDEldaAltitude, 'Color', vdLineColor), hold(app.UIAxes, 'on');
        aLegends = [aLegends, ['VD', num2str(tfElda(k,:).wavelength)]]; 

        % Detectar NaN en los valores VD
        VDhasNaN = any(isnan(cVDEldaValue), 'all');
        if VDhasNaN
            VDhasNaNCount = VDhasNaNCount +1;
            VDhasNaNMessage = [VDhasNaNMessage, [num2str(tfElda(k,:).wavelength), ' ']];
        end
        vdCount = vdCount+1;
    end
end




%% Extracting ELPP info (total_power_channel)
for k=1:height(tfElda)
    currentTPC = cell2mat(tfElda(k,:).total_power_channel);
    if isnan(currentTPC)
        disp(['No hay datos del Total Power Channel en la longitud de onda ', num2str(tfElda(k,:).wavelength)]);
    else
        cTPCElppAltitude = cell2mat(tfElda(k,:).elpp_altitude);
        cTPCElppValue = cell2mat(tfElda(k,:).total_power_channel);
       
        idx = find(cTPCElppAltitude > altMin & cTPCElppAltitude < altMax);
        cTPCElppAltitude = cTPCElppAltitude(idx);
        cTPCElppValue = cTPCElppValue(idx);
        
        %% Amplifica Total Power Channel para la longitud de onda 1064
        if tfElda(k,:).wavelength == 1064
            cTPCElppValue = cTPCElppValue * TPCmagFactor;
        end

        plot(app.UIAxes, cTPCElppValue, cTPCElppAltitude, 'Color', tfElda.attr_color{k}), hold(app.UIAxes, 'on');
        aLegends = [aLegends, ['TPC', num2str(tfElda(k,:).wavelength)]]; 

        % Detectar NaN en los valores VD
        TPChasNaN = any(isnan(cTPCElppValue), 'all');
        if TPChasNaN
            TPChasNaNCount = TPChasNaNCount +1;
            TPChasNaNMessage = [TPChasNaNMessage, [num2str(tfElda(k,:).wavelength), ' ']];
        end
    end
end

ylabel(app.UIAxes, 'Altitude');
xlabel(app.UIAxes, 'Range corrected signal');

disp(aLegends);
legend(app.UIAxes, aLegends);
grid (app.UIAxes, 'on');
hold(app.UIAxes, 'off');
pause(2);
drawnow limitrate;

if VDhasNaNCount > 0
    VDhasNaNMessage = ['Selected range between ', num2str(altMin), ' and ', num2str(altMax), ' contains at least one NaN value in the Volume Depolization vector for the wavelength(s) ', VDhasNaNMessage];
    errordlg(VDhasNaNMessage, 'Invalid values in data (NaN)');
end

if TPChasNaNCount > 0
    TPChasNaNMessage = ['Selected range between ', num2str(altMin), ' and ', num2str(altMax), ' contains at least one NaN value in the Total Power Channel vector for the wavelength(s) ', TPChasNaNMessage];
    errordlg(TPChasNaNMessage, 'Invalid values in data (NaN)');
end

disp(VDhasNaNMessage);
disp(TPChasNaNMessage);

disp(TPChasNaNCount);
disp(VDhasNaNCount);
