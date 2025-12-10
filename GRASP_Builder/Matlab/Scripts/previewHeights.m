%This script read the new CIMEL at 7 λ and Lidar SCC data and calls the WriteFiles_preGARRLiC_D1_L.m function.

% --- Step 1: Read config file ---
configFile = 'config_preview.txt';
configData = readlines(configFile);

% Initialize default values


fichero1 = '';
fichero2 = '';
fichero3 = '';


% Parse each line
for i = 1:length(configData)
    line = strtrim(configData(i));
    if startsWith(line, 'filePath_1000')
        fichero1 = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_500')
        fichero2 = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_300')
        fichero3 = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_1000_opt')
        fichero1_opt = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_500_opt')
        fichero2_opt = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_300_opt')
        fichero3_opt = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_alp')
        fichero_alp = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_inv')
        fichero_inv = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_alm')
        fichero_alm = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_aod')
        fichero_aod = (extractAfter(line, '='))
    elseif startsWith(line, 'filePath_sda')
        fichero_sda = (extractAfter(line, '='))
    
    elseif startsWith(line, 'convination')
        convination = (extractAfter(line, '='))
    end
end
%%
%%%% Read Lidar files from SCC (ELPP)
%%% Range Corrected Signals
%[fichero1,carpeta1,existe1] = uigetfile('*003_1064_*.nc','Fichero 1 pre-procesado SCC (1064 nm)');
%[fichero1,carpeta1,existe1] = uigetfile('*003_0002009_*.nc','Fichero 1 pre-procesado SCC (1064 nm)');
%cd(carpeta1)
%fichero1=filePath_1000;

Range1064 = ncread(fichero1,'altitude');
RCS1064 = ncread(fichero1,'range_corrected_signal');
start_datetime = ncreadatt(fichero1,'/','measurement_start_datetime');
start_time = start_datetime(12:19);
Meas_Date = datetime(start_datetime(1:10),'Format', 'yyyy-MM-dd');
stop_datetime = ncreadatt(fichero1,'/','measurement_stop_datetime');
stop_time = stop_datetime(12:19);
NombreEntrada1 = start_datetime;
NombreEntrada2 = start_datetime([1:4,6:7,9:13,15:16,18:end]);

%[fichero2,carpeta2,existe2] = uigetfile('*008_0532_*.nc','Fichero 2 pre-procesado SCC (532 nm)');
%[fichero2,carpeta2,existe2] = uigetfile('*008_0000936_*.nc','Fichero 2 pre-procesado SCC (532 nm)');
%[fichero2,carpeta2,existe2] = uigetfile('*008_0002035_*.nc','Fichero 2 pre-procesado SCC (532 nm)');
%cd(carpeta2)

%fichero2=filePath_500;

Range532 = ncread(fichero2,'altitude');
senal2 = ncread(fichero2,'range_corrected_signal');
RCS532 = senal2(:,1,2); 

%[fichero3,carpeta3,existe3] = uigetfile('*008_0000989_*.nc','Fichero 3 pre-procesado SCC (355 nm)');
%[fichero3,carpeta3,existe3] = uigetfile('*008_0354_*.nc','Fichero 3 pre-procesado SCC (355 nm)');
%[fichero3,carpeta3,existe3] = uigetfile('*008_0002038_*.nc','Fichero 3 pre-procesado SCC (355 nm)');
%cd(carpeta3)

%fichero3=filePath_300

Range355 = ncread(fichero3,'altitude');
senal3 = ncread(fichero3,'range_corrected_signal');
RCS355 = senal3(:,1,2);

clear senal2 senal3

figure(1)
semilogy(Range1064,RCS1064,'-r'), hold on
semilogy(Range355,RCS355,'-b')
semilogy(Range532,RCS532,'-g'), hold off
legend('1064 nm','355 nm','532 nm','Location','northeast')
legend('boxoff')
xlabel('Height')
ylabel('Lidar Signal')
%hmax = input('hmax (m) = '); %Put the hmax from Lidar Signals
%hmin = input('hmin (m) = '); %Put the hmin from Lidar Signals
% figure(1)
% plot(Range1064,RCS1064,'-r'), hold on
% plot(Range355,RCS355,'-b')
% plot(Range532,RCS532,'-g'), hold off
% legend('1064 nm','355 nm','532 nm','Location','northeast')
% legend('boxoff')
% xlabel('Height')
% ylabel('Lidar Signal')
%hmax = input('hmax (m) = '); %Put the hmax from Lidar signals
% hmin = input('hmin (m) = '); %Put the hmin from Lidar signals
waitfor(gcf); 