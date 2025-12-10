function [GARRLiC_file_name, errorVolumePolarization] = sendData_D1P_L_VD( measureID, heightMin, heightMax, isFigure, isExportLidarData)
%%! [GARRLiC_file_name, errorVolumePolarization] = sendData_D1P_L_VD( measureID, heightMin, heightMax, isFigure, isExportLidarData )
%%! *DESCRIPCIÓ*
%!
%! Recull i prepara el conjunt de dades necessàries per a la configuració
%! de la mesura que inclou dades amb despolarització del LIDAR i dades amb
%! polarització del fotòmetre perquè la funció WriteFiles_preGARRLiC_D1P_L_VD()
%! pugui crear el fitxer de sortida (*.sdat) que serà processat pel GRASP.
%!
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |measureID: [string]| -
%!      Identificador de la mesura per a la qual es recogeran les dades (*.nc).
%!
%! * |heightMin: [int]| -
%!      Altura mínima des de la qual es processaran les dades.
%!
%! * |heightMax: [int]| -
%!      Altura màxima des de la qual es processaran les dades.
%!
%! * |isFigure: [True|False]| -
%!      Indica si es desitja dibuixar les diferents gràfiques durant la
%!      recollida de dades. Aquesta funcionalitat és especialment útil per a
%!      identificar anomalias en la recollida de dades.
%!
%! * |isExportLidarData: [True|False]| -
%!      Li indica a la funció si desitja incloure en la sortida lor fitxers
%!      (*.nc) utilitzats en l'extracció de dades.
%!
%!
%! *VALORS RETORNATS*
%!
%! * |[GARRLiC_file_name]| -
%!      Nom del fitxer escrit després de processar tots les dades
%!    
    addpath('tools');
    run('config_file.m');
    
    GARRLiC_file_name = '';
    errorVolumePolarization = false;
    location = '';

    %%! Directori de sortida
    %! Crea l'estructura de directoris on es crearan els fitxers per a enviar a GRASP. El nom assignat es definirà en funció de la configuració seleccionada, la mesura i afegeix un sufix addicional que indica les altures mínima i màxima entre les quals s'han realitzat els càlculs.

    currentFolder = fileparts(mfilename('fullpath'));  
    URL_output = fullfile(currentFolder, CONFIG_output, measureID, ['D1P_L_VD-',measureID,'-', num2str(heightMin), '_', num2str(heightMax)]);

    %!
    %! Si els directoris no existeixen es creen però si existeixen no es realitza
    %! cap acció per a evitar sobreescriure els existents.

    if ~exist(URL_output, 'dir')
        mkdir(URL_output);
        logMessage('Output directory created.');
    else
        logMessage('Output directory already exists, it has not been overwritten.');
    end

    try

        %!
        %! Identifica el nom de la taula ELDA-ELPP per a carregar-la des del workspace
        elda_name = getWSTNByType('elda').table_name{1};
    
        %Carga la tabla ELDA
        tEldaElpp = evalin('base', elda_name);
    
        Range532 = NaN;
        RCS532 = NaN;
        RangeVD532 = NaN;
        VD532 = NaN;
        Range355 = NaN;
        RCS355 = NaN;
        RangeVD355 = NaN;
        VD355 = NaN;
        Range1064 = NaN;
        RCS1064 = NaN;
    
        %%! Dades LIDAR
        %! Cerca les dades ELDA i ELPP disponibles en diferents longituds d'ona 355*, 532* i 1064*
        %!
        %! * |'altitude'|
        %! * |'total_power_*channel'|
        %! * |'start_*datetime'| data i hora de l'inici de la mesura
        %! * |'stop_datetime'| data i hora de finalització de la mesura
        try
            Range532 = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).elpp_altitude{1};
            RCS532 = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).total_power_channel{1};
            RangeVD532 = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).elda_altitude{1};
            VD532 = tEldaElpp( contains(tEldaElpp.fileName, '_008_b0532_'), :).volumedepolarization{1};
            location = getLocationFromEldaFileName(tEldaElpp.fileName{1});

            start_datetime = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).elda_measurement_start_datetime;
            stop_datetime  = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).elda_measurement_stop_datetime;
        
        catch ME
            logMessage(['_b0532_', ME.message])
            if isnan(VD532)
                errorVolumePolarization = true;
            end
        end
    
        try
            Range355 = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).elpp_altitude{1};
            RCS355 = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).total_power_channel{1};
            RangeVD355 = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).elda_altitude{1};
            VD355 = tEldaElpp( contains(tEldaElpp.fileName, '_008_b0355_'), :).volumedepolarization{1};
            location = getLocationFromEldaFileName(tEldaElpp.fileName{1});

            start_datetime = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).elda_measurement_start_datetime;
            stop_datetime  = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).elda_measurement_stop_datetime;
    
        catch ME
            logMessage(['_b0355_', ME.message])
            if isnan(VD355)
                errorVolumePolarization = true;
            end
        end
    
        try
            Range1064 = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).elpp_altitude{1};
            RCS1064 = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).range_corrected_signal{1};
            location = getLocationFromEldaFileName(tEldaElpp.fileName{1});

            start_datetime = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).elda_measurement_start_datetime;
            stop_datetime  = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).elda_measurement_stop_datetime;
        
        catch ME
            logMessage(['_b1064_', ME.message])
        end
    
        
        %%! Datetime
        %! La data i hora de presa de dades usa format format ISO 8601.
        %! Per a assignar el nom al fitxer usa el format: 'yyyymmddHHMMSS'
        Meas_Date = datestr(start_datetime, 'yyyy-mm-dd');
        start_time = datestr(start_datetime, 'HH:MM:SS');
        
        %! Convertir datetime a cadena
        stop_time = datestr(stop_datetime, 'HH:MM:SS');
        
        NombreEntrada1 = [Meas_Date,'T',start_time, 'Z'];
        NombreEntrada2 = [strrep(Meas_Date, '-', ''), strrep(start_time, ':', '')];
        
    
    % clear senal2 senal3
    
        if isFigure == true
            figure(1)
            % subplot(1,2,1)
            % semilogy(Range1064,RCS1064,'-r'), hold on
            % semilogy(Range355,RCS355,'-b')
            % semilogy(Range532,RCS532,'-g'), hold off
            % legend('1064 nm','355 nm','532 nm','Location','northeast')
            % legend('boxoff')
            % xlabel('Height')
            % ylabel('Lidar Signal')
            % subplot(1,2,2)
            plot(VD355,RangeVD355,'-b'),hold on
            plot(VD532,RangeVD532,'-g'),hold off
            legend('355 nm','532 nm','Location','northwest')
            legend('boxoff')
            ylabel('Height')
            xlabel('Vol. Dep. Ratio')
            %close(figure(1));
        end
    
    %%! GRASP Range
    %! Generar vector espaiat logarítmicament de 60 punts entre la
    %! altura mínima i màxima que s'usa per a interpolar linealment els
    %! rangs i RCS de les diferents longituds d'ona.
    
    Ind = find(Range1064 >= heightMin & Range1064 <= heightMax);
    Range1064 = Range1064(Ind);
    RCS1064 = RCS1064(Ind);
    
    Ind = find(Range532 >= heightMin & Range532 <= heightMax);
    Range532 = Range532(Ind);
    RCS532 = RCS532(Ind);
    
    Ind = find(Range355 >= heightMin & Range355 <= heightMax);
    Range355 = Range355(Ind);
    RCS355 = RCS355(Ind);
    
    Ind = find(RangeVD355 >= heightMin & RangeVD355 <= heightMax);
    RangeVD355 = RangeVD355(Ind);
    VD355 = VD355(Ind);
    
    Ind = find(RangeVD532 >= heightMin & RangeVD532 <= heightMax);
    RangeVD532 = RangeVD532(Ind);
    VD532 = VD532(Ind);
    
    %Step in log scale
    Maxrange = min([max(Range1064), max(Range532), max(Range355)]);
    Minrange = max([min(Range1064), min(Range532), min(Range355)]);
    
    
    Step = (log(Maxrange)-log(Minrange))/60;
    for k = 1:60
        Rangelog(k) = log(Minrange)+((k-1)*Step);
    end
    
    Rangelog = exp(Rangelog);
    
    %Rangelog = logspace(log10(Minrange),log10(Maxrange));
    
    RCS1064log = interp1(Range1064,RCS1064,Rangelog,'linear','extrap');
    RCS532log = interp1(Range532,RCS532,Rangelog,'linear','extrap');
    RCS355log = interp1(Range355,RCS355,Rangelog,'linear','extrap');
    %Volume depolarization ranges
    %Volume depolarization profiles don't need to be normalized, the only requirement for such observations is to be presented 
    %in the percentage range i.e. [1.0e-9, 100]. The profile cannot have zeros.
    
    VD355log = interp1(RangeVD355,VD355,Rangelog,'linear','extrap');
    VD532log = interp1(RangeVD532,VD532,Rangelog,'linear','extrap');
    
    VD355log(VD355log<=0) = 1.0e-9; %Whatever is >= 0 it will be replaced by 1.0e-9 just to run GRASP.
    VD532log(VD532log<=0) = 1.0e-9;
    
    VD355log = VD355log.*100; %percentage range
    VD532log = VD532log.*100;
    
    %Profile normalization (1.0000E-15  -  1.0000E+00)
    nRCS1064log = RCS1064log./trapz(Rangelog,RCS1064log);
    nRCS1064log(nRCS1064log < 0) = abs(nRCS1064log(nRCS1064log < 0));
    nRCS532log = RCS532log./trapz(Rangelog,RCS532log);
    nRCS532log(nRCS532log < 0) = abs(nRCS532log(nRCS532log < 0));
    nRCS355log = RCS355log./trapz(Rangelog,RCS355log);
    nRCS355log(nRCS355log < 0) = abs(nRCS355log(nRCS355log < 0));
   
    %%! Generació 'GRASP_[ubicació]_'
    %! Les dades obtingudes anteriorment són emmagatzemats en un fitxer
    %! al qual se li van afegint més informació progressivament
    %!
    fullFileName = fullfile(URL_output, ['GRASP_', location, '_', NombreEntrada2, '_D1P_L_VD']);
    save(fullFileName,'Rangelog','RCS1064log','RCS532log','RCS355log','VD355log', 'VD532log', 'heightMax','heightMin','NombreEntrada2');
    
    



    %%! Perfil ELDA
    %! Afegeix les dades referents al perfil Elda per a les diferents longituds d'ona disponibles:
    %! 1064 / 532 / 355 (altitude, backscatter) i es guarden en el fitxer GRASP_BRC.
    %!
    %! Nota: Aquesta part s'ha mogut des de 'elda_profile.m per motius de
    %! unificació de dades en el fitxer GRASP_BRC
    %!
    %! *Dades a recuperar:*
    %!
    %! * |elda_altitude| - dades d'altitud del fitxer Elda.
    %! * |backscatter| - dades de backscatter del fitxer Elda
    try
        Rangebeta1064_SCC = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).elda_altitude{1};
        Beta1064_SCC = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).backscatter{1};        
        save(fullFileName,'-append','Rangebeta1064_SCC','Beta1064_SCC');
    catch ME
        logMessage(['ERROR Creating ELDA Profile for _b1064_', ME.message]);
    end
 
    try
        Rangebeta532_SCC = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).elda_altitude{1};
        Beta532_SCC = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).backscatter{1};
        save(fullFileName,'-append','Rangebeta532_SCC','Beta532_SCC');
    catch ME
        logMessage(['ERROR Creating ELDA Profile for _b0532_', ME.message]);
    end

    try
        Rangebeta355_SCC = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).elda_altitude{1};
        Beta355_SCC = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).backscatter{1};
        save(fullFileName,'-append','Rangebeta355_SCC','Beta355_SCC');
    catch ME
        logMessage(['ERROR Creating ELDA Profile for _b0355_', ME.message]);
    end

    % END of ELDA Profile
    %%


    %%! CIMEL
    %! Llegeix les mesures AOD (Aerosol Optical Depth) del fotòmetre CIMEL
    %! (tfLev15_1) usant els filtres previs de data/hora d'inici i fi.
    %! Si no coincideix el rang filtrat buscarà les coincidències més
    %! pròximes
    %!
    %! Addicionalment afegirà:
    
    timeDifference = stop_datetime - start_datetime;
    Alm = start_datetime + minutes(timeDifference/2);
    
    AlmI = start_time;
    AlmF = stop_time;
    
   
    
    T1 = evalin('base','tfLev15_1');

    Alm = T1.FullDate( round(length(T1.FullDate)/2));
    Alm.Format = 'yyyy-MM-dd HH:mm:ss';
    save(fullFileName,'-append','Alm');
   
    numT1 = datenum(T1.FullDate);  % Fechas en T1 convertidas a números
    numAlm = datenum(Alm);         % Fechas en Alm convertidas a números

    % Ind = knnsearch(datenum(T1.FullDate), datenum(Alm));
    % Calcula la diferencia absoluta entre las fechas
    diferencia = abs(numT1 - numAlm);

    % Encuentra el índice de la fecha más cercana
    [~, Ind] = min(diferencia);

    
    % [fichero4,carpeta4,existe4] = uigetfile('*.lev*','AOD from CIMEL');
    % opts = detectImportOptions(fichero4,'FileType', 'text');
    % 
    % opts.SelectedVariableNames = [2 3 5:7 10 19 22 25 26 65 74 75]; %columns referring to 1640, 1020, 870, 675, 500, 440, 380, and 340.
    % %preview('Name_file',opts)
    % ID = fopen(fichero4);
    % Date = textscan(ID,'%q %*[^\n]','Delimiter',',');
    % fclose(ID);
    % Date1 = datetime((Date{1,1}(8:end,1)),'InputFormat','dd:MM:yyyy','Format', 'yyyy-MM-dd');
    % T1 = readtable(fichero4,opts);
    % T1 = addvars(T1,Date1,'Before','Time_hh_mm_ss_');
    % Index = find(T1.Date1==Meas_Date & isbetween(T1.Time_hh_mm_ss_,AlmI,AlmF));
    % Ind = knnsearch(datenum(T1.Time_hh_mm_ss_(Index)),datenum(Alm));
    
    % T1 = evalin('base','tfLev15_1');
    %Index=find(isbetween(T1.Time_hh_mm_ss_,start_time,stop_time)); %index of start and end of the lidar measurements
    AOD1640 = T1.AOD_1640nm(Ind); %AOD1640=mean(AOD1640(AOD1640>-999));
    AOD1020 = T1.AOD_1020nm(Ind); %AOD1020=mean(AOD1020(AOD1020>-999));
    AOD870 = T1.AOD_870nm(Ind); %AOD870=mean(AOD870(AOD870>-999));
    AOD675 = T1.AOD_675nm(Ind); %AOD675=mean(AOD675(AOD675>-999));
    AOD500 = T1.AOD_500nm(Ind); %AOD500=mean(AOD500(AOD500>-999));
    AOD440 = T1.AOD_440nm(Ind); %AOD440=mean(AOD440(AOD440>-999));
    AOD380 = T1.AOD_380nm(Ind); %AOD380=mean(AOD380(AOD380>-999));
    
    AOD_AERONET = [AOD380,AOD440,AOD500,AOD675,AOD870,AOD1020,AOD1640];
      
    save(fullFileName,'-append','AOD_AERONET');


    %!
    %! * informació de l'Àngstrom Exponent (440-870 nm)
    AE440_870_AERONET = T1.x440_870_Angstrom_Exponent;

    save(fullFileName,'-append','AOD_AERONET','AE440_870_AERONET');



    
    %!
    %! * Latitud, longitud i dia del any
    latitude = T1.Site_Latitude_Degrees_(1);
    longitude = T1.Site_Longitude_Degrees_(1);
    
    % !!! ACTUALIZADO PARAA COGER SOLO EL PRIMER VALOR (LOS DÍAS NO CAMBIAN)
    DayOftheYear = T1.Day_of_Year(1);
    
    
    
    
    
    %%
    % % % %Function Vertical_profile_normalized.m
    % % % [Function_CorrectlyWrite,FMF500,AVP_fine,AVP_coarse] = Vertical_profile_normalized(hmax,hmin,Meas_Date,Rangelog,Alm,AlmI,AlmF);
    % % % save(['GRASP_BRC_', NombreEntrada2, '_D1_L'],'-append','FMF500','AVP_fine','AVP_coarse')
    %%
    
    
    
    %!
    %! * Angle del zenit solar i les radiàncies (uW/cm²/Sr\nm)
    T2 = evalin('base','tfAlm');
    % T2.Var2 => Nominal_Wavelength(nm);
    Index1640 = find(T2.('Nominal_Wavelength(nm)') == 1640); Index1640 = Index1640(1);
    Index1020 = find(T2.('Nominal_Wavelength(nm)') == 1020); Index1020 = Index1020(1); 
    Index870 = find(T2.('Nominal_Wavelength(nm)') == 870); Index870 = Index870(1);
    Index675 = find(T2.('Nominal_Wavelength(nm)') == 675); Index675 = Index675(1);
    Index500 = find(T2.('Nominal_Wavelength(nm)') == 500); Index500 = Index500(1);
    Index440 = find(T2.('Nominal_Wavelength(nm)') == 440); Index440 = Index440(1);
    Index380 = find(T2.('Nominal_Wavelength(nm)') == 380); Index380 = Index380(1);
    
    %!
    %! * Angle del zenit per a cada longitud d'ona
    SZA = T2.('Solar_Zenith_Angle(Degrees)');
    SZA1640 = SZA(Index1640);
    SZA1020 = SZA(Index1020);
    SZA870 = SZA(Index870);
    SZA675 = SZA(Index675);
    SZA500 = SZA(Index500);
    SZA440 = SZA(Index440);
    SZA380 = SZA(Index380);
    
    
    %!
    %! * Les radiàncies per a cada longitud d'ona
    rad3800 = T2{Index380,23:49};
    rad4400 = T2{Index440,23:49};
    rad5000 = T2{Index500,23:49};
    rad6750 = T2{Index675,23:49};
    rad8700 = T2{Index870,23:49};
    rad10200 = T2{Index1020,23:49};
    rad16400 = T2{Index1640,23:49};
    
    rad3801 = T2{Index380,50:76};
    rad4401 = T2{Index440,50:76};
    rad5001 = T2{Index500,50:76};
    rad6751 = T2{Index675,50:76};
    rad8701 = T2{Index870,50:76};
    rad10201 = T2{Index1020,50:76};
    rad16401 = T2{Index1640,50:76};
    
    SAA0 = [3.5 4 5 6 7 8 10 12 14 16 18 20 25 30 35 40 45 50 60 70 80 90 100 120 140 160 180];
    SAA1 = [-180,-160,-140,-120,-100,-90,-80,-70,-60,-50,-45,-40,-35,-30,-25,-20,-18,-16,-14,-12,-10,-8,-7,-6,-5,-4,-3.5];
    
    if isFigure == true
        figure(2)
        plot(SAA0,rad3800,SAA0,rad4400,SAA0,rad5000,SAA0,rad6750,SAA0,rad8700,SAA0,rad10200,SAA0,rad16400), hold on
        plot(SAA1,rad3801,SAA1,rad4401,SAA1,rad5001,SAA1,rad6751,SAA1,rad8701,SAA1,rad10201,SAA1,rad16401), hold off
        legend('380 nm','440 nm','500 nm','675 nm','870 nm','1020 nm','1640 nm')
        xlabel('Solar Zenith Angles')
        ylabel('Radiances')
        title(NombreEntrada2)
    end
    
    rad380 = [T2{Index380,23:49};fliplr(T2{Index380,50:76})]; mrad380 = mean(rad380);
    rad440 = [T2{Index440,23:49};fliplr(T2{Index440,50:76})]; mrad440 = mean(rad440);
    rad500 = [T2{Index500,23:49};fliplr(T2{Index500,50:76})]; mrad500 = mean(rad500);
    rad675 = [T2{Index675,23:49};fliplr(T2{Index675,50:76})]; mrad675 = mean(rad675);
    rad870 = [T2{Index870,23:49};fliplr(T2{Index870,50:76})]; mrad870 = mean(rad870);
    rad1020 = [T2{Index1020,23:49};fliplr(T2{Index1020,50:76})]; mrad1020 = mean(rad1020);
    rad1640 = [T2{Index1640,23:49};fliplr(T2{Index1640,50:76})]; mrad1640 = mean(rad1640);
    
    
    SAA1640 = SAA0; SAA1020 = SAA0; SAA870 = SAA0; SAA675 = SAA0; SAA500 = SAA0; SAA440 = SAA0; SAA380 = SAA0;

    %!
    %! Revisa la simetria de les mesures Almucantar i filtra les
    %! radiàncies no vàlides eliminant aquelles inferiors al 20%
    for c = 1:length(SAA0)
        A = (abs(rad1640(1,c)-rad1640(2,c)))/mrad1640(c);
        if A > 0.2
            mrad1640(c) = NaN;
        end
        A = (abs(rad1020(1,c)-rad1020(2,c)))/mrad1020(c);
        if A > 0.2
            mrad1020(c) = NaN;
        end
        A = (abs(rad870(1,c)-rad870(2,c)))/mrad870(c);
        if A > 0.2
            mrad870(c) = NaN;
        end
        A = (abs(rad675(1,c)-rad675(2,c)))/mrad675(c);
        if A > 0.2
            mrad675(c) = NaN;
        end
        A = (abs(rad500(1,c)-rad500(2,c)))/mrad500(c);
        if A > 0.2
            mrad500(c) = NaN;
        end
        A = (abs(rad440(1,c)-rad440(2,c)))/mrad440(c);
        if A > 0.2
            mrad440(c) = NaN;
        end
        A = (abs(rad380(1,c)-rad380(2,c)))/mrad380(c);
        if A > 0.2
            mrad380(c) = NaN;
        end
    end
    
    Index1640 = find(isfinite(mrad1640)); mrad1640 = mrad1640(Index1640); SAA1640 = SAA1640(Index1640);
    Index1020 = find(isfinite(mrad1020)); mrad1020 = mrad1020(Index1020); SAA1020 = SAA1020(Index1020);
    Index870 = find(isfinite(mrad870)); mrad870 = mrad870(Index870); SAA870 = SAA870(Index870);
    Index675 = find(isfinite(mrad675)); mrad675 = mrad675(Index675); SAA675 = SAA675(Index675);
    Index500 = find(isfinite(mrad500)); mrad500 = mrad500(Index500); SAA500 = SAA500(Index500);
    Index440 = find(isfinite(mrad440)); mrad440 = mrad440(Index440); SAA440 = SAA440(Index440);
    Index380 = find(isfinite(mrad380)); mrad380 = mrad380(Index380); SAA380 = SAA380(Index380);
    
    save(fullFileName,'-append','mrad380','mrad440','mrad500','mrad675','mrad870','mrad1020','mrad1640','SAA380','SAA440','SAA500','SAA675','SAA870','SAA1020','SAA1640');


    if isFigure == true
        figure(3)
        plot(SAA380,mrad380,SAA440,mrad440,SAA500,mrad500,SAA675,mrad675,SAA870,mrad870,SAA1020,mrad1020,SAA1640,mrad1640)
        legend('380 nm','440 nm','500 nm','675 nm','870 nm','1020 nm','1640 nm')
        xlabel('Solar zenith angles')
        ylabel('Radiance average')
        title(NombreEntrada2)
    end
    
    if isFigure == true
        figure(4)
        plot(SAA1640,mrad1640,SAA1020,mrad1020,SAA870,mrad870,SAA675,mrad675,SAA500,mrad500,SAA440,mrad440,SAA380,mrad380)
        legend('1640','1020','870','675','500','440','380')
        xlabel('Solar zenith angles')
        ylabel('Radiance average')
    end
    
    
    
    
    %!
    %! Converteix les radiàncies absolutes a normalitzades (radiàncies
    %! reduïdes), calcula l'angle per al dia de l'any i la distància
    %! de la Terra al Sol
    DayAngle = 2*pi*(DayOftheYear-1)/365;
    
    
    %%% Earth sun distance
    EarthSunDist = 1/(1.00011+(0.034221*cos(DayAngle))+0.00128*sin(DayAngle)+0.000719*cos(2*DayAngle)+0.000077*sin(2*DayAngle));
    
    
    %!
    %! *Nota addicional:* Extraterrestrial irradiance [Wavelength (nm) and Irradiance W/(m² nm)] "Synthetic/compòsit Extraterrestrial Spectrum by Chris Gueymard, May 2003"
    %! 380->1.0960, 440->1.848, 500->1.9320, 675->1.492, 870->0.9894, 1020->0.6972, 1640->0.2212
    %! Radiance normalized. From uW/cm² to mW/m², multiply by 10. Irradiance values for GRASP: 1.0000E-11 - 1.0000E+02
    nRadiance380 = (mrad380.*10.*pi.*EarthSunDist)/(1.0960*1000); 
    Ind = find(nRadiance380 >= 1e-11 & nRadiance380 <= 1e+02);
    nRadiance380 = nRadiance380(Ind);
    SAA380 = SAA380(Ind);
    
    nRadiance440 = (mrad440.*10.*pi.*EarthSunDist)/(1.848*1000); 
    Ind = find(nRadiance440 >= 1e-11 & nRadiance440 <= 1e+02);
    nRadiance440 = nRadiance440(Ind);
    SAA440 = SAA440(Ind);
    
    nRadiance500 = (mrad500.*10.*pi.*EarthSunDist)/(1.9320*1000); 
    Ind = find(nRadiance500 >= 1e-11 & nRadiance500 <= 1e+02);
    nRadiance500 = nRadiance500(Ind);
    SAA500 = SAA500(Ind);
    
    nRadiance675 = (mrad675.*10.*pi.*EarthSunDist)/(1.492*1000); 
    Ind = find(nRadiance675 >= 1e-11 & nRadiance675 <= 1e+02);
    nRadiance675 = nRadiance675(Ind);
    SAA675 = SAA675(Ind);
    
    nRadiance870 = (mrad870.*10.*pi.*EarthSunDist)/(0.9894*1000); 
    Ind = find(nRadiance870 >= 1e-11 & nRadiance870 <= 1e+02);
    nRadiance870 = nRadiance870(Ind);
    SAA870 = SAA870(Ind);
    
    nRadiance1020 = (mrad1020.*10.*pi.*EarthSunDist)/(0.6972*1000); 
    Ind = find(nRadiance1020 >= 1e-11 & nRadiance1020 <= 1e+02);
    nRadiance1020 = nRadiance1020(Ind);
    SAA1020 = SAA1020(Ind);
    
    nRadiance1640 = (mrad1640.*10.*pi.*EarthSunDist)/(0.2212*1000); 
    Ind = find(nRadiance1640 >= 1e-11 & nRadiance1640 <= 1e+02);
    nRadiance1640 = nRadiance1640(Ind);
    SAA1640 = SAA1640(Ind);
    
    
    save(fullFileName,'-append','nRadiance380','nRadiance440','nRadiance500','nRadiance675','nRadiance870','nRadiance1020','nRadiance1640');

    
    








    %%! AERONET
    %! Afegeix les dades de AERONET (*.all) per a comparar-los amb GRASP
    T3 = evalin('base','tfAll');
    
    radius_AERONET = str2double( T3.Properties.VariableNames(54:75) ); % Radius of the VSD
    radius_AERONET = reshape(radius_AERONET, 1, [] );
    
    %!
    %! * Índex de refracció
    RRI440 = T3.Refractive_Index_Real_Part_440nm;
    RRI675 = T3.Refractive_Index_Real_Part_675nm;
    RRI870 = T3.Refractive_Index_Real_Part_870nm;
    RRI1020 = T3.Refractive_Index_Real_Part_1020nm;
    IRI440 = T3.Refractive_Index_Imaginary_Part_440nm;
    IRI675 = T3.Refractive_Index_Imaginary_Part_675nm;
    IRI870 = T3.Refractive_Index_Imaginary_Part_870nm;
    IRI1020 = T3.Refractive_Index_Imaginary_Part_1020nm;
    RRI_AERONET = [RRI440,RRI675,RRI870,RRI1020];
    IRI_AERONET = [IRI440,IRI675,IRI870,IRI1020];
    Waves_AERONET = [440,675,870,1020];
    save(fullFileName,'-append','RRI_AERONET','IRI_AERONET','Waves_AERONET');
    
    
    %!
    %! * Albedo de Dispersió Única (SSA)
    SSA440 = T3.Single_Scattering_Albedo_440nm;
    SSA675 = T3.Single_Scattering_Albedo_675nm;
    SSA870 = T3.Single_Scattering_Albedo_870nm;
    SSA1020 = T3.Single_Scattering_Albedo_1020nm;
    SSA_AERONET = [SSA440,SSA675,SSA870,SSA1020];
    save(fullFileName,'-append','SSA_AERONET');
    
    %!
    %! * Distribució de la Grandària de Volum (VSD)
    VSD_AERONET = table2array(T3(:,54:75));
    save(fullFileName,'-append','VSD_AERONET', 'radius_AERONET');
    
    %!
    %! * Profunditat Òptica d'Aerosols d'Absorció (AAOD)
    AAOD440 = T3.Absorption_AOD_440nm;
    AAOD675 = T3.Absorption_AOD_675nm;
    AAOD870 = T3.Absorption_AOD_870nm;
    AAOD1020 = T3.Absorption_AOD_1020nm;
    AAOD_AERONET = [AAOD440,AAOD675,AAOD870,AAOD1020];
    save(fullFileName,'-append','AAOD_AERONET');
    
    %!
    %! * Factor d'Esfericitat
    SF_AERONET = T3.Sphericity_Factor;
    save(fullFileName,'-append','SF_AERONET');
    
    %!
    %! * Concentració en Volum i radi efectiu (VC, ER)
    VCT_AERONET = T3.VolC_T;
    ERT_AERONET = T3.REff_T;
    VCF_AERONET = T3.VolC_F;
    ERF_AERONET = T3.REff_F;
    VCC_AERONET = T3.VolC_C;
    ERC_AERONET = T3.REff_C;
    save(fullFileName,'-append','VCT_AERONET','ERT_AERONET','VCF_AERONET','ERF_AERONET','VCC_AERONET','ERC_AERONET');
    
    %!
    %! * Ràtio Lidar (LR)
    LR440 = T3.Lidar_Ratio_440nm;
    LR675 = T3.Lidar_Ratio_675nm;
    LR870 = T3.Lidar_Ratio_870nm;
    LR1020 = T3.Lidar_Ratio_1020nm;
    LR_AERONET = [LR440,LR675,LR870,LR1020];
    save(fullFileName,'-append','LR_AERONET');

    
    
    
    %!
    %! * Grau de polarització de l'angle azimut en graus des d'AERONET
    % opts.SelectedVariableNames = [3 5 7 12:41];
    
    T4 = evalin('base','tfAlp');
    nwl = T4.('Nominal_Wavelength(nm)');
    Index1640 = find(nwl==1640); Index1640 = Index1640(1);
    Index1020 = find(nwl==1020); Index1020 = Index1020(1);
    Index870 = find(nwl==870); Index870 = Index870(1);
    Index675 = find(nwl==675); Index675 = Index675(1);
    Index500 = find(nwl==500); Index500 = Index500(1);
    Index440 = find(nwl==440); Index440 = Index440(1);
    Index380 = find(nwl==380); Index380 = Index380(1);
    
    %!
    %! * DOLP des d'AERONET
    DOLP1640aerL = fliplr(T4{Index1640,12:26}); DOLP1640aerR = T4{Index1640,27:41};
    DOLP1020aerL = fliplr(T4{Index1020,12:26}); DOLP1020aerR = T4{Index1020,27:41};
    DOLP870aerL = fliplr(T4{Index870,12:26}); DOLP870aerR = T4{Index870,27:41};
    DOLP675aerL = fliplr(T4{Index675,12:26}); DOLP675aerR = T4{Index675,27:41};
    DOLP500aerL = fliplr(T4{Index500,12:26}); DOLP500aerR = T4{Index500,27:41};
    DOLP440aerL = fliplr(T4{Index440,12:26}); DOLP440aerR = T4{Index440,27:41};
    DOLP380aerL = fliplr(T4{Index380,12:26}); DOLP380aerR = T4{Index380,27:41};
    
    mDOLP380aer = mean([DOLP380aerL;DOLP380aerR]);
    mDOLP440aer = mean([DOLP440aerL;DOLP440aerR]);
    mDOLP500aer = mean([DOLP500aerL;DOLP500aerR]);
    mDOLP675aer = mean([DOLP675aerL;DOLP675aerR]);
    mDOLP870aer = mean([DOLP870aerL;DOLP870aerR]);
    mDOLP1020aer = mean([DOLP1020aerL;DOLP1020aerR]);
    mDOLP1640aer = mean([DOLP1640aerL;DOLP1640aerR]);
    
    DOLP380aer = [DOLP380aerL;DOLP380aerR];
    DOLP440aer = [DOLP440aerL;DOLP440aerR];
    DOLP500aer = [DOLP500aerL;DOLP500aerR];
    DOLP675aer = [DOLP675aerL;DOLP675aerR];
    DOLP870aer = [DOLP870aerL;DOLP870aerR];
    DOLP1020aer = [DOLP1020aerL;DOLP1020aerR];
    DOLP1640aer = [DOLP1640aerL;DOLP1640aerR];
    
    PAA = [25 30 35 40 45 50 60 70 80 90 100 110 120 140 160];
    
    %!
    %! Realitza una prova de simetria
    for c = 1:length(PAA)
        A = (abs(DOLP1640aer(1,c)-DOLP1640aer(2,c)))/mDOLP1640aer(c);
        if A > 0.2
            mDOLP1640aer(c) = NaN;
        end
        A = (abs(DOLP1020aer(1,c)-DOLP1020aer(2,c)))/mDOLP1020aer(c);
        if A > 0.2
            mDOLP1020aer(c) = NaN;
        end
        A = (abs(DOLP870aer(1,c)-DOLP870aer(2,c)))/mDOLP870aer(c);
        if A > 0.2
            mDOLP870aer(c) = NaN;
        end
        A = (abs(DOLP675aer(1,c)-DOLP675aer(2,c)))/mDOLP675aer(c);
        if A > 0.2
            mDOLP675aer(c) = NaN;
        end
        A = (abs(DOLP500aer(1,c)-DOLP500aer(2,c)))/mDOLP500aer(c);
        if A > 0.2
            mDOLP500aer(c) = NaN;
        end
        A = (abs(DOLP440aer(1,c)-DOLP440aer(2,c)))/mDOLP440aer(c);
        if A > 0.2
            mDOLP440aer(c) = NaN;
        end
        A = (abs(DOLP380aer(1,c)-DOLP380aer(2,c)))/mDOLP380aer(c);
        if A > 0.2
            mDOLP380aer(c) = NaN;
        end
    end
    
    Index1640 = find(isfinite(mDOLP1640aer)); mDOLP1640aer = mDOLP1640aer(Index1640); PAA1640 = PAA(Index1640);
    Index1020 = find(isfinite(mDOLP1020aer)); mDOLP1020aer = mDOLP1020aer(Index1020); PAA1020 = PAA(Index1020);
    Index870 = find(isfinite(mDOLP870aer)); mDOLP870aer = mDOLP870aer(Index870); PAA870 = PAA(Index870);
    Index675 = find(isfinite(mDOLP675aer)); mDOLP675aer = mDOLP675aer(Index675); PAA675 = PAA(Index675);
    Index500 = find(isfinite(mDOLP500aer)); mDOLP500aer = mDOLP500aer(Index500); PAA500 = PAA(Index500);
    Index440 = find(isfinite(mDOLP440aer)); mDOLP440aer = mDOLP440aer(Index440); PAA440 = PAA(Index440);
    Index380 = find(isfinite(mDOLP380aer)); mDOLP380aer = mDOLP380aer(Index380); PAA380 = PAA(Index380);

    save(fullFileName,'-append','mDOLP380aer','PAA380','mDOLP440aer','PAA440','mDOLP500aer','PAA500','mDOLP675aer','PAA675','mDOLP870aer','PAA870','mDOLP1020aer','PAA1020','mDOLP1640aer','PAA1640','PAA');


    if isFigure == true
        figure(5)
        plot(PAA380,mDOLP380aer,PAA440,mDOLP440aer,PAA500,mDOLP500aer,PAA675,mDOLP675aer,PAA870,mDOLP870aer,PAA1020,mDOLP1020aer,PAA1640,mDOLP1640aer)
        legend('380 nm','440 nm','500 nm','675 nm','870 nm','1020 nm','1640 nm')
        xlabel('Polarized Azimuth Angles')
        ylabel('DOLP_{AERONET}')
        title(NombreEntrada2)
    end
    
    %%
    %Other variables
    ground_height = 0; %surface measurements
    SolarAzimuthAngle = [3 3.5 4 5 6 7 8 10 12 14 16 18 20 25 30 35 40 45 50 60 70 80 90 100 120 140 160 180];
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    AAD_ALP_Key = {'Azimuth_Angle(Degrees)_-160','Azimuth_Angle(Degrees)_-140','Azimuth_Angle(Degrees)_-120','Azimuth_Angle(Degrees)_-110','Azimuth_Angle(Degrees)_-100','Azimuth_Angle(Degrees)_-90','Azimuth_Angle(Degrees)_-80','Azimuth_Angle(Degrees)_-70','Azimuth_Angle(Degrees)_-60','Azimuth_Angle(Degrees)_-50','Azimuth_Angle(Degrees)_-45','Azimuth_Angle(Degrees)_-40','Azimuth_Angle(Degrees)_-35','Azimuth_Angle(Degrees)_-30','Azimuth_Angle(Degrees)_-25','Azimuth_Angle(Degrees)_25','Azimuth_Angle(Degrees)_30','Azimuth_Angle(Degrees)_35','Azimuth_Angle(Degrees)_40','Azimuth_Angle(Degrees)_45','Azimuth_Angle(Degrees)_50','Azimuth_Angle(Degrees)_60','Azimuth_Angle(Degrees)_70','Azimuth_Angle(Degrees)_80','Azimuth_Angle(Degrees)_90','Azimuth_Angle(Degrees)_100','Azimuth_Angle(Degrees)_110','Azimuth_Angle(Degrees)_120','Azimuth_Angle(Degrees)_140','Azimuth_Angle(Degrees)_160'};
    AAD_ALP_Value = {-160,-140,-120,-110,-100,-90,-80,-70,-60,-50,-45,-40,-35,-30,-25,25,30,35,40,45,50,60,70,80,90,100,110,120,140,160};
    mADD_ALP = containers.Map(AAD_ALP_Key, AAD_ALP_Value);
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isFigure == true
        figure(3)
        plot(PAA380,mDOLP380aer,PAA440,mDOLP440aer,PAA500,mDOLP500aer,PAA675,mDOLP675aer,PAA870,mDOLP870aer,PAA1020,mDOLP1020aer,PAA1640,mDOLP1640aer)
        legend('380 nm','440 nm','500 nm','675 nm','870 nm','1020 nm','1640 nm')
        xlabel('Polarized Azimuth Angles')
        ylabel('DOLP_{AERONET}')
        title(NombreEntrada2)
    end
    
    %%
    %Other variables
    ground_height = 0; %surface measurements
    SolarAzimuthAngle = [3 3.5 4 5 6 7 8 10 12 14 16 18 20 25 30 35 40 45 50 60 70 80 90 100 120 140 160 180];
   
    
    
        %!
        %%! Escriptura preGARRLiC
        %! Una vegada recollit totes les dades s'envien a la funció
        %! |WriteFiles_preGARRLiC_D1P_L_VD(...)| encarregada d'escriure el fitxer
        %! de sortida SDAT. Si s'escriu correctament retornarà el nom
        %! de l'arxiu creat.
    [GARRLiC_file_name] = WriteFiles_preGARRLiC_D1P_L_VD(measureID, URL_output, latitude,longitude,ground_height,SZA380,SZA440,SZA500,...
        SZA675,SZA870,SZA1020,SZA1640,SAA380,SAA440,SAA500,SAA675,SAA870,SAA1020,SAA1640,AOD380,nRadiance380,AOD440,...
        nRadiance440,AOD500,nRadiance500,AOD675,nRadiance675,AOD870,nRadiance870,AOD1020,nRadiance1020,AOD1640,...
        nRadiance1640,PAA1640,mDOLP1640aer,PAA1020,mDOLP1020aer,PAA870,mDOLP870aer,PAA675,mDOLP675aer,PAA500,mDOLP500aer,...
        PAA440,mDOLP440aer,PAA380,mDOLP380aer,Rangelog,VD355log,VD532log,nRCS355log,nRCS532log,nRCS1064log,NombreEntrada1,NombreEntrada2);
   
        %% If user want to export lidar data it's copy the output folder
        if isExportLidarData 
            exportLidarData(measureID, URL_output);            
        end

        % clear all

    catch ME
        logMessage(ME.identifier);
        logMessage(ME.message);
        if errorVolumePolarization 
            logMessage('ERROR: Volume Polarization missing data || Please check LIDAR Volume Polarization avaliability in ''008'' files || Affected fields: VD355, VD532, RangeVD355, RangeVD532');
        end
    end
end
            