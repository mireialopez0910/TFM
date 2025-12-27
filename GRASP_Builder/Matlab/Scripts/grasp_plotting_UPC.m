function[GRASP_Plot_Correctly] = grasp_plotting_UPC(path2file, config, Lambda,Waves_AERONET2,size_binsF,size_binsC)
%%! [GRASP_Plot_Correctly] = grasp_plotting_UPC(path2file, Lambda,Waves_AERONET2,size_binsF,size_binsC)
%!
%%! Descripció
%!
%! Realitza els càlculs necessaris per a representar gràficament els productes derivats del GRASP.
%! Concretament, crea dues versions de cada gràfica:
%! 
%! * Creant un fitxer |.fig| que permet visualitzar directament la gràfica des de l'arxiu
%! * Creant un fitxer |.mat| que conté totes les dades necessàries per a
%! representar cadascuna de les gràfiques en ser invocades amb la funció dataToPlot(...)
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |path2file: [string]| - 
%!      El camí on els fitxers necessaris per a realitzar els càlculs i representar-los gràficament es localitzen.
%!
%! * |Lambda: [double vector]| -
%!      Totes les longituds d'ona de la radiació d'incidència utilitzades dins del GRASP.
%!      Entrades (355, 380, 440, 500, 532, 675, 870, 1020, 1064, 1640).
%!
%! * |Waves_AERONET2: [double vector]| - 
%!      Totes les longituds d'ona del fotòmetre AERONET utilitzades dins les entrades del GRASP.
%!      Entrades (380, 440, 500, 675, 870, 1020, 1640).
%!
%! * |size_binsF: [double vector]| - 
%!      Intervals de distribució de la grandària de les partícules petites.
%!
%! * |size_binsC: [double vector]| - 
%!      Intervals de distribució de la grandària de les partícules grans.
%!
%!
%! *VALORS DE RETORN*
%!
%! * |[int]| - Retorna |0| si no es troben els fitxers OUT o GRASP i |1| si el procés de càlcul i dibuix és correcte
%!

    close all
   
    try
        graspOutFile = ['UPC_', config,'_out.txt'];
        graspPreGARRLiC = dir( fullfile(path2file, 'GRASP_*.mat') );
    
        % Previene que no cargue ficheros GRASP_DATA_*
        graspPreGARRLiC = graspPreGARRLiC(~contains({graspPreGARRLiC.name}, '_DATA_'));
    
        % Extrae la localización de la medida usando el nombre del fichero '.mat'
        graspFileName =  graspPreGARRLiC(1).name;
        disp(['GRASP_MAT: ', graspFileName]);
    
        underscores = strfind(graspFileName, '_');
        result = graspFileName(underscores(1)+1 : underscores(2)-1);
        ubi = upper(result);
    catch e
       disp(e.message);
    end

    if (exist( fullfile(graspPreGARRLiC.folder, graspOutFile), 'file') == 2 && exist( fullfile(graspPreGARRLiC.folder, graspPreGARRLiC.name), 'file' ) == 2)
    
        load(fullfile(graspPreGARRLiC.folder, graspPreGARRLiC.name) );
        
        range_location = fliplr(Rangelog);
        Hmax = heightMax; Hmin = heightMin;
        n355 = find(Rangebeta355_SCC <= Hmax);
        n532 = find(Rangebeta532_SCC <= Hmax);
        n1064 = find(Rangebeta1064_SCC <= Hmax);
        range355SSC = Rangebeta355_SCC(n355)./1000;
        range532SSC = Rangebeta532_SCC(n532)./1000; 
        range1064SCC = Rangebeta1064_SCC(n1064)./1000;
        Beta355SSC = Beta355_SCC(n355).*10^6;
        Beta532SSC = Beta532_SCC(n532).*10^6;
        Beta1064SSC = Beta1064_SCC(n1064).*10^6;
        % Ext355SSC = Ext355_SCC(n355).*10^6;
        % Ext532SSC = Ext532_SCC(n532).*10^6;
        Hmax = Hmax./1000; Hmin = Hmin./1000;
        
        grasp_data_filename = read_data_error(path2file, 'UPC_D1_L_outcsv.txt', graspPreGARRLiC.name, ubi);
        load( fullfile(path2file, grasp_data_filename) ); %load grasp_data
        
        %%! Preparació de dades
        %!
        dateproc = datenum(fecha{2},'yyyy-mm-ddTHH:MM:SSZ');
        %station = 'Barcelona';
        %altitude = eval(['range_' station]);
        station = ubi;
        altitude = range_location;
        altitude = altitude./1000;
       
   
        %! * Perfils verticals d'aerosol. Es van multiplicar per 1000.
        %!
        num_layers = length(who('VertProfileNormalized*_1'))
        AVPF_D1_L_GRASP = zeros(num_layers, 1);
        for j = 1:num_layers
            % j
            % % AVPF_D1_L_GRASP(j,1) = 10^3*eval(sprintf('VertProfileNormalized%i_1',j))
            % Error_AVPF_D1_L_GRASP(j,1) = 10^3*eval(sprintf('errest_VertProfileNormalized%i_1',j))
            % std_AVPF_D1_L_GRASP(j,1) = 10^3*eval(sprintf('std_VertProfileNormalized%i_1',j))
            % bias_AVPF_D1_L_GRASP(j,1) = 10^3*eval(sprintf('bias_VertProfileNormalized%i_1',j))
            % for j = 1:num_layers
                % Get the actual data using 'evalin' or 'eval'
                sprintf('VertProfileNormalized%i_1',j)
                % Construct the variable name
                varName = sprintf('VertProfileNormalized%i_1', j);
                
                % Get the data from the workspace
                raw_data = eval(varName)
                
                % If it's a character/string, convert it to a double
                if ischar(raw_data) || isstring(raw_data)
                    disp('char')
                    numeric_val = str2double(raw_data)
                else
                    disp('num')
                    numeric_val = raw_data % It's already numeric
                end
                
                % Now perform the math safely
                if ~isnan(numeric_val)
                    AVPF_D1_L_GRASP(j,1) = 10^3 * numeric_val
                end
                
            end
        % end
        % clearvars VertProfileNormalized*_1 errest_VertProfileNormalized*_1 
        
    
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','AVPF_D1_L_GRASP','Error_AVPF_D1_L_GRASP','std_AVPF_D1_L_GRASP','bias_AVPF_D1_L_GRASP');
        
        for j = 1:length(who('VertProfileNormalized*_2'))
            AVPC_D1_L_GRASP(j,1) = 10^3*eval(sprintf('VertProfileNormalized%i_2',j));
            Error_AVPC_D1_L_GRASP(j,1) = 10^3*eval(sprintf('errest_VertProfileNormalized%i_2',j));
            std_AVPC_D1_L_GRASP(j,1) = 10^3*eval(sprintf('std_VertProfileNormalized%i_2',j));
            bias_AVPC_D1_L_GRASP(j,1) = 10^3*eval(sprintf('bias_VertProfileNormalized%i_2',j));
        end
        % clearvars VertProfileNormalized*_2 errest_VertProfileNormalized*_2 
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','AVPC_D1_L_GRASP','Error_AVPC_D1_L_GRASP','std_AVPC_D1_L_GRASP','bias_AVPC_D1_L_GRASP');
         

        %! * Distribució de la mida del volum
        %!
        for j = 1:length(who('SizeDistrTriangBin*_1'))
            VSDF_D1_L_GRASP(j,1) = eval(sprintf('SizeDistrTriangBin%i_1',j));
            Error_VSDF_D1_L_GRASP(j,1) = eval(sprintf('errest_SizeDistrTriangBin%i_1',j));
            std_VSDF_D1_L_GRASP(j,1) = eval(sprintf('std_SizeDistrTriangBin%i_1',j));
            bias_VSDF_D1_L_GRASP(j,1) = eval(sprintf('bias_SizeDistrTriangBin%i_1',j));
        end
    
        % clearvars SizeDistrTriangBin*_1 errest_SizeDistrTriangBin*_1
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','VSDF_D1_L_GRASP','Error_VSDF_D1_L_GRASP','std_VSDF_D1_L_GRASP','bias_VSDF_D1_L_GRASP','bias_VSDF_D1_L_GRASP');
    
        for j = 1:length(who('SizeDistrTriangBin*_2'))
            VSDC_D1_L_GRASP(j,1) = eval(sprintf('SizeDistrTriangBin%i_2',j));
            Error_VSDC_D1_L_GRASP(j,1) = eval(sprintf('errest_SizeDistrTriangBin%i_2',j));
            std_VSDC_D1_L_GRASP(j,1) = eval(sprintf('std_SizeDistrTriangBin%i_2',j));
            bias_VSDC_D1_L_GRASP(j,1) = eval(sprintf('bias_SizeDistrTriangBin%i_2',j));
        end
    
        % clearvars SizeDistrTriangBin*_2 errest_SizeDistrTriangBin*_2 
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','VSDC_D1_L_GRASP','Error_VSDC_D1_L_GRASP','std_VSDC_D1_L_GRASP','bias_VSDC_D1_L_GRASP');
    
        
        %! * AAOD
        %!
        for j = 1:length(Lambda)
            ld = Lambda(j);
            aaodF_D1_L_GRASP(j,1) = eval(sprintf('aaod%i_0',ld));
            clear ld
        end
        % clearvars aaod*_0 
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            aaodC_D1_L_GRASP(j,1) = eval(sprintf('aaod%i_1',ld));
            clear ld
        end
        % clearvars aaod*_1 
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            aaod_D1_L_GRASP(j,1) = eval(sprintf('aaod%i',ld));
            clear ld
        end

        % clearvars aaod* -except aaod0 aaod1 aaod          
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','aaod_D1_L_GRASP','aaodC_D1_L_GRASP','aaodF_D1_L_GRASP');
        

        %! * SSA
        %!
        for j = 1:length(Lambda)
            ld = Lambda(j);
            ssaF_D1_L_GRASP(j,1) = eval(sprintf('ssa%i_0',ld));
            Error_ssaF_D1_L_GRASP(j,1) = eval(sprintf('errest_ssa%i_0',ld));
            std_ssaF_D1_L_GRASP(j,1) = eval(sprintf('std_ssa%i_0',ld));
            bias_ssaF_D1_L_GRASP(j,1) = eval(sprintf('bias_ssa%i_0',ld));
            clear ld
        end
        % clearvars ssa*_0 errest_ssa*_0
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            ssaC_D1_L_GRASP(j,1) = eval(sprintf('ssa%i_1',ld));
            Error_ssaC_D1_L_GRASP(j,1) = eval(sprintf('errest_ssa%i_1',ld));
            std_ssaC_D1_L_GRASP(j,1) = eval(sprintf('std_ssa%i_1',ld));
            bias_ssaC_D1_L_GRASP(j,1) = eval(sprintf('bias_ssa%i_1',ld));
            clear ld
        end
        % clearvars ssa*_1 errest_ssa*_1
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            ssa_D1_L_GRASP(j,1) = eval(sprintf('ssa%i',ld));
            Error_ssa_D1_L_GRASP(j,1) = eval(sprintf('errest_ssa%i',ld));
            std_ssa_D1_L_GRASP(j,1) = eval(sprintf('std_ssa%i',ld));
            bias_ssa_D1_L_GRASP(j,1) = eval(sprintf('bias_ssa%i',ld));
            clear ld
        end
        % clearvars ssa* errest_ssa* -except ssa0 ssa1 ssa      
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','ssa_D1_L_GRASP','ssaC_D1_L_GRASP','ssaF_D1_L_GRASP','Error_ssa_D1_L_GRASP','std_ssa_D1_L_GRASP','bias_ssa_D1_L_GRASP','Error_ssaC_D1_L_GRASP','std_ssaC_D1_L_GRASP','bias_ssaC_D1_L_GRASP','Error_ssaF_D1_L_GRASP','std_ssaF_D1_L_GRASP','bias_ssaF_D1_L_GRASP');
        

        %! * AOD
        %!
        for j = 1:length(Lambda)
            ld = Lambda(j);
            AODF_D1_L_GRASP(j,1) = eval(sprintf('tau%i_0',ld));
            Error_AODF_D1_L_GRASP(j,1) = eval(sprintf('errest_tau%i_0',ld));
            std_AODF_D1_L_GRASP(j,1) = eval(sprintf('std_tau%i_0',ld));
            bias_AODF_D1_L_GRASP(j,1) = eval(sprintf('bias_tau%i_0',ld));
            clear ld
        end
        % clearvars tau*_0 
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            AODC_D1_L_GRASP(j,1) = eval(sprintf('tau%i_1',ld));
            Error_AODC_D1_L_GRASP(j,1) = eval(sprintf('errest_tau%i_1',ld));
            std_AODC_D1_L_GRASP(j,1) = eval(sprintf('std_tau%i_1',ld));
            bias_AODC_D1_L_GRASP(j,1) = eval(sprintf('bias_tau%i_1',ld));
            clear ld
        end
        % clearvars tau*_1 
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            aod_D1_L_GRASP(j,1) = eval(sprintf('tau%i',ld));
            Error_aod_D1_L_GRASP(j,1) = eval(sprintf('errest_tau%i',ld));
            std_aod_D1_L_GRASP(j,1) = eval(sprintf('std_tau%i',ld));
            bias_aod_D1_L_GRASP(j,1) = eval(sprintf('bias_tau%i',ld));
            clear ld
        end
        % clearvars tau* -except tau0 tau1 tau      
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','aod_D1_L_GRASP','Error_aod_D1_L_GRASP','std_aod_D1_L_GRASP','bias_aod_D1_L_GRASP','AODC_D1_L_GRASP','AODF_D1_L_GRASP','Error_AODF_D1_L_GRASP','bias_AODC_D1_L_GRASP','std_AODC_D1_L_GRASP','Error_AODC_D1_L_GRASP','std_AODF_D1_L_GRASP','bias_AODF_D1_L_GRASP');
    
        
        %! * Relació Lidar
        %!
        for j = 1:length(Lambda)
            ld = Lambda(j);
            LRF_D1_L_GRASP(j,1) = eval(sprintf('lidar_ratio%i_0',ld));
            % Error_LRF_D1_L_GRASP(j,1) = eval(sprintf('errest_lr%i_0',ld));
            std_LRF_D1_L_GRASP(j,1) = eval(sprintf('std_lr%i_0',ld));
            bias_LRF_D1_L_GRASP(j,1) = eval(sprintf('bias_lr%i_0',ld));
            clear ld
        end
        % clearvars lidar_ratio*_0 errest_lr*_0
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            LRC_D1_L_GRASP(j,1) = eval(sprintf('lidar_ratio%i_1',ld));
            % Error_LRC_D1_L_GRASP(j,1) = eval(sprintf('errest_lr%i_1',ld));
            std_LRC_D1_L_GRASP(j,1) = eval(sprintf('std_lr%i_1',ld));
            bias_LRC_D1_L_GRASP(j,1) = eval(sprintf('bias_lr%i_1',ld));
            clear ld
        end
        % clearvars lidar_ratio*_1 errest_lr*_1
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            LR_D1_L_GRASP(j,1) = eval(sprintf('lidar_ratio%i',ld));
            Error_LR_D1_L_GRASP(j,1) = eval(sprintf('errest_lr%i',ld));
            std_LR_D1_L_GRASP(j,1) = eval(sprintf('std_lr%i',ld));
            bias_LR_D1_L_GRASP(j,1) = eval(sprintf('bias_lr%i',ld));
            clear ld
        end
        % clearvars lidar_ratio* errest_lr* -except LR0 LR1 LR       
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','LR_D1_L_GRASP','LRC_D1_L_GRASP','LRF_D1_L_GRASP','Error_LR_D1_L_GRASP','std_LR_D1_L_GRASP','bias_LR_D1_L_GRASP','std_LRC_D1_L_GRASP','bias_LRC_D1_L_GRASP','std_LRF_D1_L_GRASP','bias_LRF_D1_L_GRASP');
    
        
        %! * Índex de refracció imaginària (reff_index_imag)
        %!
        for j = 1:length(Lambda)
            ld = Lambda(j);
            RIIF_D1_L_GRASP(j,1) = eval(sprintf('ImagRefIndSpect%i_1',ld));
            Error_RIIF_D1_L_GRASP(j,1) = eval(sprintf('errest_ImagRefIndSpect%i_1',ld));
            std_RIIF_D1_L_GRASP(j,1) = eval(sprintf('std_ImagRefIndSpect%i_1',ld));
            bias_RIIF_D1_L_GRASP(j,1) = eval(sprintf('bias_ImagRefIndSpect%i_1',ld));
            clear ld
        end
        % clearvars ImagRefIndSpect*_1 
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            RIIC_D1_L_GRASP(j,1) = eval(sprintf('ImagRefIndSpect%i_2',ld));
            Error_RIIC_D1_L_GRASP(j,1) = eval(sprintf('errest_ImagRefIndSpect%i_2',ld));
            std_RIIC_D1_L_GRASP(j,1) = eval(sprintf('std_ImagRefIndSpect%i_2',ld));
            bias_RIIC_D1_L_GRASP(j,1) = eval(sprintf('bias_ImagRefIndSpect%i_2',ld));
            clear ld
        end
        % clearvars ImagRefIndSpect*_2
        

        %! * Estimació del índex de refracció imaginària (reff_index_imag)
        %! 

        % estIRI_D1_L3B = ((RIIF.*AVCF) + (RIIC.*AVCC))./(AVCF+AVCC);
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','RIIF_D1_L_GRASP','RIIC_D1_L_GRASP','Error_RIIF_D1_L_GRASP','Error_RIIC_D1_L_GRASP','std_RIIC_D1_L_GRASP','std_RIIF_D1_L_GRASP','bias_RIIC_D1_L_GRASP','bias_RIIF_D1_L_GRASP');
        
        %! * Índex de refracció real
        %!
        for j = 1:length(Lambda)
            ld = Lambda(j);
            RIRF_D1_L_GRASP(j,1) = eval(sprintf('RealRefIndSpect%i_1',ld));
            Error_RIRF_D1_L_GRASP(j,1) = eval(sprintf('errest_RealRefIndSpect%i_1',ld));
            std_RIRF_D1_L_GRASP(j,1) = eval(sprintf('std_RealRefIndSpect%i_1',ld));
            bias_RIRF_D1_L_GRASP(j,1) = eval(sprintf('bias_RealRefIndSpect%i_1',ld));
            clear ld
        end
        % clearvars RealRefIndSpect*_1 
    
        for j = 1:length(Lambda)
            ld = Lambda(j);
            RIRC_D1_L_GRASP(j,1) = eval(sprintf('RealRefIndSpect%i_2',ld));
            Error_RIRC_D1_L_GRASP(j,1) = eval(sprintf('errest_RealRefIndSpect%i_2',ld));
            std_RIRC_D1_L_GRASP(j,1) = eval(sprintf('std_RealRefIndSpect%i_2',ld));
            bias_RIRC_D1_L_GRASP(j,1) = eval(sprintf('bias_RealRefIndSpect%i_2',ld));
            clear ld
        end
        % clearvars RealRefIndSpect*_2 
        
        
        %! * Estimació de l'índex de refracció real (reff_index_real)
        %!

        % estRIR_D1_L3B = ((RIRF.*AVCF) + (RIRC.*AVCC))./(AVCF+AVCC);
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','RIRC_D1_L_GRASP','RIRF_D1_L_GRASP','Error_RIRF_D1_L_GRASP','Error_RIRC_D1_L_GRASP','std_RIRC_D1_L_GRASP','std_RIRF_D1_L_GRASP','bias_RIRC_D1_L_GRASP','bias_RIRF_D1_L_GRASP');
    

        %! * Soroll residual, relatiu i absolut.
        %!
        for j = 1:length(who('residual_absolute_noise*'))
            Noise_abs_D1_L_GRASP(j,1)=eval(sprintf('residual_absolute_noise%i',j-1));
            Noise_rel_D1_L_GRASP(j,1)=eval(sprintf('residual_relative_noise%i',j-1));
        end
        % clearvars residual*_noise* 
        
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','Noise_abs_D1_L_GRASP','Noise_rel_D1_L_GRASP')        
    

        %! * Perfils d'extinció i retrodispersió a 355 nm, 532 nm i 1064 nm, respectivament.
        %!
        AlfaF_D1_L_GRASP = AVPF_D1_L_GRASP.*tau355_0; AlfaC_D1_L_GRASP = AVPC_D1_L_GRASP.*tau355_1; %Pag. 54- Doc. GRASP
        Alfa355_D1_L_GRASP = (AlfaF_D1_L_GRASP + AlfaC_D1_L_GRASP);
        % ErrAlfa355_D1_L_GRASP = (sqrt(((Error_AVPF_D1_L_GRASP.*tau355_0).^2)+((AVPF_D1_L_GRASP.*errest_tau355_0).^2)+((Error_AVPC_D1_L_GRASP.*tau355_1).^2)+((AVPC_D1_L_GRASP.*errest_tau355_1).^2))).*10^6; 
        BetaF_D1_L_GRASP = AlfaF_D1_L_GRASP./lidar_ratio355_0; BetaC_D1_L_GRASP = AlfaC_D1_L_GRASP./lidar_ratio355_1; %Pag. 54- Doc. GRASP
        Beta355_D1_L_GRASP = (BetaF_D1_L_GRASP + BetaC_D1_L_GRASP);
        % ErrBeta355_D1_L_GRASP = (sqrt((((tau355_0/lidar_ratio355_0).*Error_AVPF_D1_L_GRASP).^2)+(((AVPF_D1_L_GRASP./lidar_ratio355_0).*errest_tau355_0).^2)+(((((tau355_0.*AVPF_D1_L_GRASP))./(lidar_ratio355_0^2)).*errest_lr355_0).^2)+(((tau355_1/lidar_ratio355_1).*Error_AVPC_D1_L_GRASP).^2)+(((AVPC_D1_L_GRASP/lidar_ratio355_1).*errest_tau355_1).^2)+(((((tau355_1.*AVPC_D1_L_GRASP)./(lidar_ratio355_1^2))).*errest_lr355_1).^2))).*10^6;
        
        AlfaF_D1_L_GRASP = AVPF_D1_L_GRASP.*tau532_0; AlfaC_D1_L_GRASP = AVPC_D1_L_GRASP.*tau532_1; %Pag. 54- Doc. GRASP
        Alfa532_D1_L_GRASP = (AlfaF_D1_L_GRASP + AlfaC_D1_L_GRASP);
        % ErrAlfa532_D1_L_GRASP = (sqrt(((Error_AVPF_D1_L_GRASP.*tau532_0).^2)+((AVPF_D1_L_GRASP.*errest_tau532_0).^2)+((Error_AVPC_D1_L_GRASP.*tau532_1).^2)+((AVPC_D1_L_GRASP.*errest_tau532_1).^2))).*10^6; 
        BetaF_D1_L_GRASP = AlfaF_D1_L_GRASP./lidar_ratio532_0; BetaC_D1_L_GRASP = AlfaC_D1_L_GRASP./lidar_ratio532_1; %Pag. 54- Doc. GRASP
        Beta532_D1_L_GRASP = (BetaF_D1_L_GRASP + BetaC_D1_L_GRASP);
        % ErrBeta532_D1_L_GRASP = (sqrt((((tau532_0/lidar_ratio532_0).*Error_AVPF_D1_L_GRASP).^2)+(((AVPF_D1_L_GRASP./lidar_ratio532_0).*errest_tau532_0).^2)+(((((tau532_0.*AVPF_D1_L_GRASP))./(lidar_ratio532_0^2)).*errest_lr532_0).^2)+(((tau532_1/lidar_ratio532_1).*Error_AVPC_D1_L_GRASP).^2)+(((AVPC_D1_L_GRASP/lidar_ratio532_1).*errest_tau532_1).^2)+(((((tau532_1.*AVPC_D1_L_GRASP)./(lidar_ratio532_1^2))).*errest_lr532_1).^2))).*10^6;
        
        AlfaF_D1_L_GRASP = AVPF_D1_L_GRASP.*tau1064_0; AlfaC_D1_L_GRASP = AVPC_D1_L_GRASP.*tau1064_1; %Pag. 54- Doc. GRASP
        Alfa1064_D1_L_GRASP = (AlfaF_D1_L_GRASP + AlfaC_D1_L_GRASP);
        % ErrAlfa1064_D1_L_GRASP = (sqrt(((Error_AVPF_D1_L_GRASP.*tau1064_0).^2)+((AVPF_D1_L_GRASP.*errest_tau1064_0).^2)+((Error_AVPC_D1_L_GRASP.*tau1064_1).^2)+((AVPC_D1_L_GRASP.*errest_tau1064_1).^2))).*10^6; 
        BetaF_D1_L_GRASP = AlfaF_D1_L_GRASP./lidar_ratio1064_0; BetaC_D1_L_GRASP = AlfaC_D1_L_GRASP./lidar_ratio1064_1; %Pag. 54- Doc. GRASP
        Beta1064_D1_L_GRASP = (BetaF_D1_L_GRASP + BetaC_D1_L_GRASP);
        % ErrBeta1064_D1_L_GRASP = (sqrt((((tau1064_0/lidar_ratio1064_0).*Error_AVPF_D1_L_GRASP).^2)+(((AVPF_D1_L_GRASP./lidar_ratio1064_0).*errest_tau1064_0).^2)+(((((tau1064_0.*AVPF_D1_L_GRASP))./(lidar_ratio1064_0^2)).*errest_lr1064_0).^2)+(((tau1064_1/lidar_ratio1064_1).*Error_AVPC_D1_L_GRASP).^2)+(((AVPC_D1_L_GRASP/lidar_ratio1064_1).*errest_tau1064_1).^2)+(((((tau1064_1.*AVPC_D1_L_GRASP)./(lidar_ratio1064_1^2))).*errest_lr1064_1).^2))).*10^6;
        
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','Alfa355_D1_L_GRASP','Beta355_D1_L_GRASP','Alfa532_D1_L_GRASP','Beta532_D1_L_GRASP','Alfa1064_D1_L_GRASP','Beta1064_D1_L_GRASP');        
        

        %! * Perfil d'absorció d'aerosols a 355 nm, 532 nm i 1064 nm, respectivament.
        %!
        AlfaabsF_D1_L_GRASP = AVPF_D1_L_GRASP.*aaod355_0; AlfaabsC_D1_L_GRASP = AVPC_D1_L_GRASP.*aaod355_1; %Pag. 54- Doc. GRASP
        Alfaabs355_D1_L_GRASP = (AlfaabsF_D1_L_GRASP + AlfaabsC_D1_L_GRASP);
        %ErrAlfaabs355 = (sqrt(((Error_VC1.*aaod355_0).^2)+((VC1.*errest_tau355_0).^2)+((Error_VC2.*tau355_1).^2)+((VC2.*errest_tau355_1).^2))).*10^6; 
        
        AlfaabsF_D1_L_GRASP = AVPF_D1_L_GRASP.*aaod532_0; AlfaabsC_D1_L_GRASP = AVPC_D1_L_GRASP.*aaod532_1; %Pag. 54- Doc. GRASP
        Alfaabs532_D1_L_GRASP = (AlfaabsF_D1_L_GRASP + AlfaabsC_D1_L_GRASP);
        %ErrAlfa532 = (sqrt(((Error_VC1.*tau532_0).^2)+((VC1.*errest_tau532_0).^2)+((Error_VC2.*tau532_1).^2)+((VC2.*errest_tau532_1).^2))).*10^6; 
        
        AlfaabsF_D1_L_GRASP = AVPF_D1_L_GRASP.*aaod1064_0; AlfaabsC_D1_L_GRASP = AVPC_D1_L_GRASP.*aaod1064_1; %Pag. 54- Doc. GRASP
        Alfaabs1064_D1_L_GRASP = (AlfaabsF_D1_L_GRASP + AlfaabsC_D1_L_GRASP);
        %ErrAlfa1064 = (sqrt(((Error_VC1.*tau1064_0).^2)+((VC1.*errest_tau1064_0).^2)+((Error_VC2.*tau1064_1).^2)+((VC2.*errest_tau1064_1).^2))).*10^6; 
        
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','Alfaabs355_D1_L_GRASP','Alfaabs532_D1_L_GRASP','Alfaabs1064_D1_L_GRASP');        
    

        %! * Perfils SSA
        %!
        SSA355_D1_L_GRASP = (Alfa355_D1_L_GRASP-Alfaabs355_D1_L_GRASP)./Alfa355_D1_L_GRASP;     
        SSA532_D1_L_GRASP = (Alfa532_D1_L_GRASP-Alfaabs532_D1_L_GRASP)./Alfa532_D1_L_GRASP;
        SSA1064_D1_L_GRASP = (Alfa1064_D1_L_GRASP-Alfaabs1064_D1_L_GRASP)./Alfa1064_D1_L_GRASP;
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','SSA355_D1_L_GRASP','SSA532_D1_L_GRASP','SSA1064_D1_L_GRASP');        
    

        %! * Perfils de relació Lidar
        %!
        LR355_D1_L_GRASP = Alfa355_D1_L_GRASP./Beta355_D1_L_GRASP;       
        LR532_D1_L_GRASP = Alfa532_D1_L_GRASP./Beta532_D1_L_GRASP;       
        LR1064_D1_L_GRASP = Alfa1064_D1_L_GRASP./Beta1064_D1_L_GRASP;
        % LR355SCC = Alfa355./Beta355;       
        % LR532SCC = Alfa532./Beta532;       
        
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','LR355_D1_L_GRASP','LR532_D1_L_GRASP','LR1064_D1_L_GRASP')%,'LR355SCC','LR532SCC');
    

        %! * Perfils Angstrom
        %!
        AE355_532_D1_L_GRASP = (-log(Beta355_D1_L_GRASP./Beta532_D1_L_GRASP))./(log(355/532));       
        AE355_1064_D1_L_GRASP = (-log(Beta355_D1_L_GRASP./Beta1064_D1_L_GRASP))./(log(355/1064));        
        AE532_1064_D1_L_GRASP = (-log(Beta532_D1_L_GRASP./Beta1064_D1_L_GRASP))./(log(532/1064));
        AE_D1_L_GRASP = eval(sprintf('AExp'));
        % AE355_532SCC = (-log(Beta355./Beta532))./(log(355/532));       
        % AE355_1064SCC = (-log(Beta355./Beta1064))./(log(355/1064));        
        % AE532_1064SCC = (-log(Beta532./Beta1064))./(log(532/1064));
        
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','AE355_532_D1_L_GRASP','AE355_1064_D1_L_GRASP','AE532_1064_D1_L_GRASP','AE_D1_L_GRASP');%,'AE355_532SCC','AE355_1064SCC','AE532_1064SCC');       
        

        %! * Fracció de l'esfera
        %!
        SF_D1_L_GRASP = eval(sprintf('SphereFraction'));
        Error_SF_D1_L_GRASP = eval(sprintf('errest_SphereFraction'));
        std_SF_D1_L_GRASP = eval(sprintf('std_SphereFraction'));
        bias_SF_D1_L_GRASP = eval(sprintf('bias_SphereFraction'));
        EffRT_D1_L_GRASP = eval(sprintf('sd_effective_radii_total'));
        EffRF_D1_L_GRASP = eval(sprintf('sd_effective_radii_fine'));
        EffRC_D1_L_GRASP = eval(sprintf('sd_effective_radii_coarse'));
        save([fullfile(path2file, ['GRASP_', ubi, '_', NombreEntrada2, '_', config])],'-append','EffRC_D1_L_GRASP','EffRF_D1_L_GRASP','EffRT_D1_L_GRASP','Error_SF_D1_L_GRASP','SF_D1_L_GRASP','std_SF_D1_L_GRASP','bias_SF_D1_L_GRASP');        
    

    %%! Gràfiques representades
    %!

    screenResolution = get(0, 'ScreenSize');

    % Create figure folder
    figuresDir = fullfile(path2file,'figures');
    if ~exist(figuresDir, 'dir')
        mkdir(figuresDir);
        disp('Carpeta ''figures'' creada.');
    else
        disp('La carpeta ''figures'' ya existe, no se ha sobrescrito.');
    end
    

    %! * Perfils verticals de aerosol
    %!   
    h1 = figure('Visible', 'on');
    plot(AVPF_D1_L_GRASP,altitude,'b', AVPC_D1_L_GRASP,altitude,'r')
    xlabel('AVP, (Mm^{-1})')
    ylabel('Height asl, (km)')
    box('on');
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])
    grid('on');
    ylim([Hmin, Hmax])
    legend('GRASP-Fine','GRASP-Coarse')
    legend('boxoff')
    savefig(h1, fullfile(path2file, ['figures/AVP_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/AVP_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {AVPF_D1_L_GRASP, altitude, AVPC_D1_L_GRASP, altitude};
    dataFigureColor = {'b','r'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'AVP, (Mm^{-1})';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');





    %! * VSD (GRASP x AERONET)
    %!
    h2 = figure('Visible', 'on');    
    plot(size_binsF,VSDF_D1_L_GRASP,'b',size_binsC,VSDC_D1_L_GRASP,'r'),hold on
    plot(radius_AERONET,VSD_AERONET,'k'),hold off
    ylabel('VSD, (/mum^3//mum^2)')
    xlabel('Radius, (/mum)')
    xlim([0.01,100])
    box on
    legend('GRASP-Fine','GRASP-Coarse','AERONET')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])
    grid on
    set(gca, 'XScale', 'log')
    savefig(h2, fullfile(path2file, ['figures/VSD_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/VSD_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {size_binsF, VSDF_D1_L_GRASP, size_binsC, VSDC_D1_L_GRASP, radius_AERONET, VSD_AERONET};
    dataFigureColor = {'b','r', 'k'};
    dataFigureYLabel = 'VSD, (/mum^3//mum^2)';
    dataFigureXLabel = 'Radius, (/mum)';
    dataFigureXLim = [0.01, 100];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {'XScale', 'log'};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');


    %! * IRI (GRASP x AERONET) 
    %!
    h3 = figure('Visible', 'on');
    plot(Lambda,RIIF_D1_L_GRASP,'-ob',Lambda,RIIC_D1_L_GRASP,'-or'), hold on
    plot(Waves_AERONET,IRI_AERONET,':*k'),hold off
    ylabel('IRI')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','AERONET')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')]) 
    grid on
    savefig(h3, fullfile(path2file, ['figures/IRI_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/IRI_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,RIIF_D1_L_GRASP, Lambda,RIIC_D1_L_GRASP, Waves_AERONET,IRI_AERONET};
    dataFigureColor = {'-ob','-or', ':*k'};
    dataFigureYLabel = 'IRI';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * RRI (GRASP x AERONET)
    %!
    h4 = figure('Visible', 'on');
    plot(Lambda,RIRF_D1_L_GRASP,'-ob',Lambda,RIRC_D1_L_GRASP,'-or'),hold on
    plot(Waves_AERONET,RRI_AERONET,':*k'),hold off
    ylabel('RRI')
    xlabel('/lambda, (nm)')    
    legend('GRASP-Fine','GRASP-Coarse','AERONET')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')]) 
    grid on
    savefig(h4, fullfile(path2file, ['figures/RRI_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/RRI_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,RIRF_D1_L_GRASP, Lambda,RIRC_D1_L_GRASP, Waves_AERONET,RRI_AERONET};
    dataFigureColor = {'-ob','-or', ':*k'};
    dataFigureYLabel = 'RRI';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * AAOD (GRASP x AERONET)
    %!
    h5 = figure('Visible', 'on');
    plot(Lambda,aaodF_D1_L_GRASP,'-ob',Lambda,aaodC_D1_L_GRASP,'-or',Lambda,aaod_D1_L_GRASP,'-ok'),hold on
    plot(Waves_AERONET,AAOD_AERONET,':*k'),hold off
    ylabel('AAOD')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h5, fullfile(path2file, ['figures/aaod_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/aaod_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,aaodF_D1_L_GRASP, Lambda,aaodC_D1_L_GRASP, Lambda,aaod_D1_L_GRASP, Waves_AERONET,AAOD_AERONET};
    dataFigureColor = {'-ob','-or', '-ok', ':*k'};
    dataFigureYLabel = 'AAOD';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');


    
    %! * SSA (GRASP x AERONET)
    %!
    h6 = figure('Visible', 'on');
    plot(Lambda,ssaF_D1_L_GRASP,'-ob',Lambda,ssaC_D1_L_GRASP,'-or',Lambda,ssa_D1_L_GRASP,'-ok'),hold on
    plot(Waves_AERONET,SSA_AERONET,':*k'),hold off
    ylabel('SSA')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')]) 
    grid on
    savefig(h6, fullfile(path2file, ['figures/ssa_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/ssa_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,ssaF_D1_L_GRASP, Lambda,ssaC_D1_L_GRASP, Lambda,ssa_D1_L_GRASP, Waves_AERONET,SSA_AERONET};
    dataFigureColor = {'-ob', '-or', '-ok', ':*k'};
    dataFigureYLabel = 'SSA';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * AOD (GRASP x AERONET)
    %!
    h7 = figure('Visible', 'on');
    plot(Lambda,AODF_D1_L_GRASP,'-ob',Lambda,AODC_D1_L_GRASP,'-or',Lambda,aod_D1_L_GRASP,'-ok'),hold on
    plot(Waves_AERONET2,AOD_AERONET,':*k'),hold off
    ylabel('AOD')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')]) 
    grid on
    savefig(h7, fullfile(path2file, ['figures/aod_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/aod_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,AODF_D1_L_GRASP, Lambda,AODC_D1_L_GRASP, Lambda,aod_D1_L_GRASP, Waves_AERONET2,AOD_AERONET};
    dataFigureColor = {'-ob', '-or', '-ok', ':*k'};
    dataFigureYLabel = 'AOD';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * LR (GRASP x AERONET)
    %!
    h8 = figure('Visible', 'on');    
    hold on
    plot(Lambda,LRF_D1_L_GRASP,'-ob',Lambda,LRC_D1_L_GRASP,'-or',Lambda,LR_D1_L_GRASP,'-ok'),hold on
    plot(Waves_AERONET,LR_AERONET,':*k'),hold off
    ylabel('LR, (sr)')
    xlabel('/lambda, (nm)')
    box on
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h8, fullfile(path2file, ['figures/LR_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/LR_' config '_GRASPxAERONET_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,LRF_D1_L_GRASP, Lambda,LRC_D1_L_GRASP, Lambda,LR_D1_L_GRASP, Waves_AERONET,LR_AERONET};
    dataFigureColor = {'-ob', '-or', '-ok', ':*k'};
    dataFigureYLabel = 'LR, (sr)';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total','AERONET'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * Perfils d'extinció
    %!
    h9 = figure('Visible', 'on');    
    hold on
    plot(Alfa355_D1_L_GRASP,altitude,'b',Alfa532_D1_L_GRASP,altitude,'g',Alfa1064_D1_L_GRASP,altitude,'r')
    ylabel('Height asl (km)')
    xlabel('Extinction (Mm^{-1})')
    box on
    ylim([Hmin, Hmax])
    legend('/alpha 355 nm','/alpha 532 nm','/alpha 1064 nm')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])    
    grid on
    savefig(h9, fullfile(path2file, ['figures/Extinction_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/Extinction_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Alfa355_D1_L_GRASP,altitude, Alfa532_D1_L_GRASP,altitude, Alfa1064_D1_L_GRASP,altitude};
    dataFigureColor = {'b', 'g', 'r'};
    dataFigureYLabel = 'Height asl (km)';
    dataFigureXLabel = 'Extinction (Mm^{-1})';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'/alpha 355 nm','/alpha 532 nm','/alpha 1064 nm'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * Perfils de retrodispersió d'aerosols
    %!
    h10 = figure('Visible', 'on');    
    hold on
    plot(Beta355_D1_L_GRASP,altitude,'b',Beta532_D1_L_GRASP,altitude,'g',Beta1064_D1_L_GRASP,altitude,'r')
    ylabel('Height asl, (km)')
    xlabel('Backscatter, (Mm^{-1}sr^{-1})')
    box on
    ylim([Hmin, Hmax])
    legend('/beta 355 nm','/beta 532 nm','/beta 1064 nm')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h10, fullfile(path2file, ['figures/Backscatter_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/Backscatter_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Beta355_D1_L_GRASP,altitude, Beta532_D1_L_GRASP,altitude, Beta1064_D1_L_GRASP,altitude};
    dataFigureColor = {'b', 'g', 'r'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'Backscatter, (Mm^{-1}sr^{-1})';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'/beta 355 nm','/beta 532 nm','/beta 1064 nm'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * Perfils d'absorció d'aerosols
    %!
    h11 = figure('Visible', 'on');    
    hold on
    plot(Alfaabs355_D1_L_GRASP,altitude,'b',Alfaabs532_D1_L_GRASP,altitude,'g',Alfaabs1064_D1_L_GRASP,altitude,'r')
    ylabel('Height asl, (km)')
    xlabel('Absorption, (Mm^{-1})')
    box on
    ylim([Hmin, Hmax])
    legend('/alpha_{abs} 355 nm','/alpha_{abs} 532 nm','/alpha_{abs} 1064 nm')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])     
    grid on
    savefig(h11, fullfile(path2file, ['figures/Absorption_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/Absorption_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Alfaabs355_D1_L_GRASP, altitude, Alfaabs532_D1_L_GRASP, altitude, Alfaabs1064_D1_L_GRASP, altitude};
    %dataFigureAxis = {Alfaabs355_D1_L_GRASP, altitude};
    dataFigureColor = {'b','g','r'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'Absorption, (Mm^{-1})';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'/alpha_{abs} 355 nm', '/alpha_{abs} 532 nm','/alpha_{abs} 1064 nm'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');


    %! * Perfils SSA
    %!
    h12 = figure('Visible', 'on');    
    hold on
    plot(SSA355_D1_L_GRASP,altitude,'b',SSA532_D1_L_GRASP,altitude,'g',SSA1064_D1_L_GRASP,altitude,'r')
    ylabel('Height asl, (km)')
    xlabel('SSA')
    box on
    ylim([Hmin, Hmax])
    legend('SSA 355 nm','SSA 532 nm','SSA 1064 nm')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])    
    grid on
    savefig(h12, fullfile(path2file, ['figures/SSA_Prof_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/SSA_Prof_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {SSA355_D1_L_GRASP,altitude, SSA532_D1_L_GRASP,altitude, SSA1064_D1_L_GRASP,altitude};
    dataFigureColor = {'b', 'g', 'r'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'SSA';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'SSA 355 nm','SSA 532 nm','SSA 1064 nm'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * Perfils LR
    %!
    h13 = figure('Visible', 'on');    
    hold on
    plot(LR355_D1_L_GRASP,altitude,'b',LR532_D1_L_GRASP,altitude,'g',LR1064_D1_L_GRASP,altitude,'r')
    ylabel('Height asl, (km)')
    xlabel('LR, (sr)')
    box on
    ylim([Hmin, Hmax])
    legend('LR 355 nm','LR 532 nm','LR 1064 nm')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h13, fullfile(path2file, ['figures/LR_Prof_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/LR_Prof_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {LR355_D1_L_GRASP,altitude, LR532_D1_L_GRASP,altitude, LR1064_D1_L_GRASP,altitude};
    dataFigureColor = {'b', 'g', 'r'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'LR, (sr)';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'LR 355 nm','LR 532 nm','LR 1064 nm'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * Perfils Angstrom
    %!
    h14 = figure('Visible', 'on');    
    hold on
    plot(AE355_532_D1_L_GRASP,altitude,'k',AE532_1064_D1_L_GRASP,altitude,'--k',AE355_1064_D1_L_GRASP,altitude,':k')
    ylabel('Height asl, (km)')
    xlabel('AE')
    box on
    ylim([Hmin, Hmax])
    legend('AE_{(355-532)}','AE_{(532-1064)}','AE_{(355-1064)}')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])      
    grid on
    savefig(h14, fullfile(path2file, ['figures/AE_Prof_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/AE_Prof_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {AE355_532_D1_L_GRASP,altitude, AE532_1064_D1_L_GRASP,altitude, AE355_1064_D1_L_GRASP,altitude};
    dataFigureColor = {'k', '--k', ':k'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'AE';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'AE_{(355-532)}','AE_{(532-1064)}','AE_{(355-1064)}'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * Retrodispersió (GRASP x SCC)
    %!
    h15 = figure('Visible', 'on');
    hold on
    plot(Beta355SSC,range355SSC,'b',Beta532SSC,range532SSC,'g',Beta1064SSC,range1064SCC,'r')
    plot(Beta355_D1_L_GRASP,altitude,'--b',Beta532_D1_L_GRASP,altitude,'--g',Beta1064_D1_L_GRASP,altitude,'--r')
    ylabel('Height asl, (km)')
    xlabel('Backscatter, (Mm^{-1}sr^{-1})')
    box on
    ylim([Hmin, Hmax])
    legend('SCC-355 nm','SCC-532 nm','SCC-1064 nm','GRASP-355 nm','GRASP-532 nm','GRASP-1064 nm')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])      
    grid on
    savefig(h15, fullfile(path2file, ['figures/Beta_' config '_SCCxGRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/Beta_' config '_SCCxGRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Beta355SSC, range355SSC, Beta532SSC, range532SSC, Beta1064SSC, range1064SCC, Beta355_D1_L_GRASP, altitude, Beta532_D1_L_GRASP, altitude, Beta1064_D1_L_GRASP, altitude};
    dataFigureColor = {'b', 'g', 'r','--b', '--g','--r'};
    dataFigureYLabel = 'Height asl, (km)';
    dataFigureXLabel = 'Backscatter, (Mm^{-1}sr^{-1})';
    dataFigureXLim = [];
    dataFigureYLim = [Hmin, Hmax];
    dataFigureLegend = {'SCC-355 nm','SCC-532 nm','SCC-1064 nm','GRASP-355 nm','GRASP-532 nm','GRASP-1064 nm'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * VSD
    %!
    h16 = figure('Visible', 'on');    
    hold on
    plot(size_binsF,VSDF_D1_L_GRASP,'b',size_binsC,VSDC_D1_L_GRASP,'r')
    ylabel('VSD, (/mum^3//mum^2)')
    xlabel('Radius, (/mum)')
    box on
    legend('GRASP-Fine','GRASP-Coarse')
    legend('boxoff')
    xlim([0.01,100])
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])
    grid on
    set(gca, 'XScale', 'log')
    savefig(h16, fullfile(path2file, ['figures/VSD_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/VSD_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {size_binsF,VSDF_D1_L_GRASP, size_binsC, VSDC_D1_L_GRASP};
    dataFigureColor = {'b', 'r'};
    dataFigureYLabel = 'VSD, (/mum^3//mum^2)';
    dataFigureXLabel = 'Radius, (/mum)';
    dataFigureXLim = [0.01,100];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {'XScale', 'log'};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * IRI
    %!
    h17 = figure('Visible', 'on');
    plot(Lambda,RIIF_D1_L_GRASP,'-ob',Lambda,RIIC_D1_L_GRASP,'-or')
    ylabel('IRI')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h17, fullfile(path2file, ['figures/IRI_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/IRI_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,RIIF_D1_L_GRASP, Lambda, RIIC_D1_L_GRASP};
    dataFigureColor = {'-ob', '-or'};
    dataFigureYLabel = 'IRI';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * RRI
    %!
    h18 = figure('Visible', 'on');
    plot(Lambda,RIRF_D1_L_GRASP,'-ob',Lambda,RIRC_D1_L_GRASP,'-or')
    ylabel('RRI')
    xlabel('/lambda, (nm)')    
    legend('GRASP-Fine','GRASP-Coarse')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h18, fullfile(path2file, ['figures/RRI_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/RRI_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,RIRF_D1_L_GRASP, Lambda,RIRC_D1_L_GRASP};
    dataFigureColor = {'-ob', '-or'};
    dataFigureYLabel = 'RRI';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');


    %! * AAOD
    %!
    h19 = figure('Visible', 'on');
    plot(Lambda,aaodF_D1_L_GRASP,'-ob',Lambda,aaodC_D1_L_GRASP,'-or',Lambda,aaod_D1_L_GRASP,'-ok')
    ylabel('AAOD')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h19, fullfile(path2file, ['figures/aaod_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/aaod_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,aaodF_D1_L_GRASP, Lambda,aaodC_D1_L_GRASP, Lambda,aaod_D1_L_GRASP};
    dataFigureColor = {'-ob', '-or', '-ok'};
    dataFigureYLabel = 'AAOD';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');



    %! * SSA
    %!
    h20 = figure('Visible', 'on');
    plot(Lambda,ssaF_D1_L_GRASP,'-ob',Lambda,ssaC_D1_L_GRASP,'-or',Lambda,ssa_D1_L_GRASP,'-ok')
    ylabel('SSA')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h20, fullfile(path2file, ['figures/ssa_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/ssa_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,ssaF_D1_L_GRASP, Lambda,ssaC_D1_L_GRASP, Lambda,ssa_D1_L_GRASP};
    dataFigureColor = {'-ob', '-or', '-ok'};
    dataFigureYLabel = 'SSA';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');




    %! * AOD
    %!
    h21 = figure('Visible', 'on');
    plot(Lambda,AODF_D1_L_GRASP,'-ob',Lambda,AODC_D1_L_GRASP,'-or',Lambda,aod_D1_L_GRASP,'-ok')
    ylabel('AOD')
    xlabel('/lambda, (nm)')
    legend('GRASP-Fine','GRASP-Coarse','GRASP-Total')
    legend('boxoff')
    title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])  
    grid on
    savefig(h21, fullfile(path2file, ['figures/aod_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']));    

    % Figure Data model
    dataFigureName = fullfile(path2file, ['figures/aod_' config '_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.mat']);
    dataFigureAxis = {Lambda,AODF_D1_L_GRASP, Lambda,AODC_D1_L_GRASP, Lambda,aod_D1_L_GRASP};
    dataFigureColor = {'-ob', '-or', '-ok'};
    dataFigureYLabel = 'AOD';
    dataFigureXLabel = '/lambda, (nm)';
    dataFigureXLim = [];
    dataFigureYLim = [];
    dataFigureLegend = {'GRASP-Fine','GRASP-Coarse','GRASP-Total'};
    dataFigureTitle = [station ', ' datestr(dateproc,'yyyymmdd HH:MM')];
    dataFigureLogScale = {};
    save(dataFigureName, 'dataFigureAxis', 'dataFigureColor', 'dataFigureYLabel', 'dataFigureXLabel', 'dataFigureYLim', 'dataFigureXLim', 'dataFigureLegend', 'dataFigureTitle', 'dataFigureLogScale');




    %%%% Extinció (GRASP x SCC)
    %
    %     h22=figure('Position',[200 200 800 600]);    
    %     hold on
    %     plot(Ext355SSC,ranges355SSC,'b',Ext532SSC,ranges532SSC,'g')
    %     plot(Alfa355_G,altitude,'--b',Alfa532_G,altitude,'--g',Alfa1064_G,altitude,'--r'), hold off
    % %     boundedline(Lambda,LR0,Error_LR0,'-ob',Lambda,LR1,Error_LR1,'-or',Lambda,LR,Error_LR,'-ok')
    %     ylabel('Height asl (m)')
    %     xlabel('Extinction (Mm^{-1}sr^{-1})')
    %     box on
    %     ylim([Hmin, Hmax])
    %     legend('SCC-355 nm','SCC-532 nm','GRASP-355 nm','GRASP-532 nm','GRASP-1064 nm')
    %     legend('boxoff')
    %     title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])   
    %     grid on
    %     hgsave(h22,['figures/Alpha_SCCxGRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']);    
    
    %%%% LR profiles (GRASP x SCC)
    %
    %     h23=figure('Position',[200 200 800 600]);    
    %     hold on
    %     plot(LR355SCC,ranges355SSC,'b',LR355SCC,ranges532SSC,'g')
    %     plot(Alfa355_G,altitude,'--b',Alfa532_G,altitude,'--g',Alfa1064_G,altitude,'--r'), hold off
    % %     boundedline(Lambda,LR0,Error_LR0,'-ob',Lambda,LR1,Error_LR1,'-or',Lambda,LR,Error_LR,'-ok')
    %     ylabel('Height asl (m)')
    %     xlabel('Extinction (Mm^{-1}sr^{-1})')
    %     box on
    %     ylim([Hmin, Hmax])
    %     legend('SCC-355 nm','SCC-532 nm','GRASP-355 nm','GRASP-532 nm','GRASP-1064 nm')
    %     legend('boxoff')
    %     title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])      
    %     hgsave(h23,['figures/LR_SCCxGRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']);

    %%%% Angstrom profiles (GRASP x SCC)
    %     h14=figure('Position',[200 200 800 600]);    
    %     hold on
    %     plot(AE355_532SCC,altitude,'b',AE532_1064SCC,altitude,'--g',AE355_1064SCC,altitude,':r')
    %     plot(AE355_532,altitude,'k',AE532_1064,altitude,'--k',AE355_1064,altitude,':k')
    % %     boundedline(Lambda,LR0,Error_LR0,'-ob',Lambda,LR1,Error_LR1,'-or',Lambda,LR,Error_LR,'-ok')
    %     ylabel('Height asl (km)')
    %     xlabel('AE')
    %     box on
    %     ylim([Hmin, Hmax])
    %     legend('AE_{(355-532)}','AE_{(532-1064)}','AE_{(355-1064)}')
    %     legend('boxoff')
    %     title ([station ', ' datestr(dateproc,'yyyymmdd HH:MM')])     
    %     grid on
    %     hgsave(h14,['figures/AE_Prof_GRASP_' station '_' datestr(dateproc,'yymmddHHMM') '.fig']);
    
    %%
        clearvars -except rawdata i Lambda size_bins* range_Granada range_Barcelona range_location
        %delete grasp_data.mat
    
        close all
        GRASP_Plot_Correctly = 1;
    else
        disp('Ficheros OUT o GRASP no encontrados');
        GRASP_Plot_Correctly = 0;
        errordlg('OUT or GRASP files not found');

    end
end