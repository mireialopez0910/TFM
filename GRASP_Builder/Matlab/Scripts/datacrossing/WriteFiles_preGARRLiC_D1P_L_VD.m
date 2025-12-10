function [GARRLiC_file_name] = WriteFiles_preGARRLiC_UPC_D1P_L_VD(measureID, outPath, latitude,longitude,ground_height,...
    SZA380,SZA440,SZA500,SZA675,SZA870,SZA1020,SZA1640,SAA380,SAA440,SAA500,SAA675,SAA870,SAA1020,SAA1640,...
    AOD380,Radiancia380,AOD440,Radiancia440,AOD500,Radiancia500,AOD675,Radiancia675,AOD870,Radiancia870,...
    AOD1020,Radiancia1020,AOD1640,Radiancia1640,PAA1640,mPol1640,PAA1020,mPol1020,PAA870,mPol870,PAA675,...
    mPol675,PAA500,mPol500,PAA440,mPol440,PAA380,mPol380,RangeIni,VD355,VD532,LS355,LS532,LS1064,NombreEntrada1,NombreEntrada2)
%%! [GARRLiC_file_name] = WriteFiles_preGARRLiC_UPC_D1P_L_VD(measureID, outPath, latitude, longitude, ground_height, SZA380, SZA440, SZA500, SZA675, SZA870, SZA1020, SZA1640, SAA380, SAA440, SAA500, SAA675, SAA870, SAA1020, SAA1640, AOD380, Radiancia380, AOD440, Radiancia440, AOD500, Radiancia500, AOD675, Radiancia675, AOD870, Radiancia870, AOD1020, Radiancia1020, AOD1640, Radiancia1640, PAA1640, mPol1640, PAA1020, mPol1020, PAA870, mPol870, PAA675, mPol675, PAA500, mPol500, PAA440, mPol440, PAA380, mPol380, RangeIni, VD355,VD532, LS355, LS532, LS1064, NombreEntrada1, NombreEntrada2)
%%! DESCRIPCIÓ
%!
%! Aquesta funció prepara el fitxer 'SDATA' per a la inversió garrlic amb 
%! l'AOD (7λ) + irradiances + grau de polarització + 3 RCS de lidar para la
%! configuració de LIDAR sense informació de la despolarització de volum y del fotómetre
%! amb informació de polarització.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * measureID - Identificador de la mesura.
%! * outPath - Ruta de l'arxiu.
%! * latitude - Latitud de la presa de mesures.
%! * longitude - Latitud de la presa de mesures.
%! * ground_height - Alçada des del terra.
%! * SZA380 - Angle del zenit solar per a la longitud de l'ona de 380 nm
%! * SZA440 - Angle del zenit solar per a la longitud de l'ona de 440 nm
%! * SZA500 - Angle del zenit solar per a la longitud d'ona de 500 nm
%! * SZA675 - Angle del zenit solar per a la longitud de l'ona de 675 nm
%! * SZA870 - Angle del zenit solar per a la longitud de l'ona de 870 nm
%! * SZA1020 - Angle del zenit solar per a la longitud de l'ona de 1020 nm
%! * SZA1640 - Angle del zenit solar per a la longitud de l'ona de 1640 nm
%! * SAA380 - Angle azimut solar per a la longitud de l'ona de 380 nm
%! * SAA440 - Angle azimut solar per a la longitud de l'ona de 440 nm
%! * SAA500 - Angle azimut solar per a la longitud de l'ona de 500 nm
%! * SAA675 - Angle azimut solar per a la longitud de l'ona de 675 nm
%! * SAA870 - Angle azimut solar per a la longitud de l'ona de 870 nm
%! * SAA1020 - Angle azimut solar per a la longitud de l'ona de 1020 nm
%! * SAA1640 - Angle azimut solar per a la longitud de l'ona de 1640 nm
%! * AOD380 - Profunditat òptica de l'aerosol per a la longitud d'ona de 380 nm
%! * Radiancia380 - Radiància per a la longitud d'ona de 380 nm
%! * AOD440 - Profunditat òptica de l'aerosol per a la longitud d'ona de 440 nm
%! * Radiancia440 - Radiància per a la longitud d'ona de 440 nm
%! * AOD500 - Profunditat òptica de l'aerosol per a la longitud d'ona de 500 nm
%! * Radiancia500 - Radiància per a la longitud d'ona de 500 nm
%! * AOD675 - Profunditat òptica de l'aerosol per a la longitud de l'ona de 675 nm
%! * Radiancia675 - Radiància per a la longitud d'ona de 675 nm
%! * AOD870 - Profunditat òptica de l'aerosol per a la longitud d'ona de 870 nm
%! * Radiancia870 - Radiància per a la longitud d'ona de 870 nm
%! * AOD1020 - Profunditat òptica de l'aerosol per a la longitud de l'ona de 1020 nm
%! * Radiancia1020 - Radiància per a la longitud d'ona de 1020 nm
%! * AOD1640 - Profunditat òptica de l'aerosol per a la longitud de l'ona de 1640 nm
%! * Radiancia1640 - Radiància per a la longitud d'ona de 1640 nm
%! * PAA1640 - angle azimutal principal a 640 nm
%! * mPol1640 - magnitud de la polarización a 1640 nm
%! * PAA1020 - angle azimutal principal a 1020
%! * mPol1020 - magnitud de la polarització a 1020 nm
%! * PAA870 - angle azimutal principal a 870
%! * mPol870 - - magnitud de la polarització a 870 nm
%! * PAA675 - angle azimutal principal a 675
%! * mPol675 - magnitud de la polarització a 675 nm
%! * PAA500 - angle azimutal principal a 500
%! * mPol500 - magnitud de la polarització a 500 nm
%! * PAA440 - angle azimutal principal a 440
%! * mPol440 - magnitud de la polarització a 440 nm
%! * PAA380 - angle azimutal principal a 380
%! * mPol380 - magnitud de la polarització a 1360 nm
%! * RangeIni - Rang inicial de distància del perfil LIDAR.
%! * VD355 - Depolarització volumètrica a 355 nm
%! * VD532 - Depolarització volumètrica a 532 nm
%! * LS355 - senyal lidar a 355 nm
%! * LS532 - senyal lidar a 532 nm
%! * LS1064 - senyal lidar a 1064 nm
%! * NombreEntrada1 - Nom afegit al contingut del fitxer GARRLIC
%! * NombreEntrada2 - Nom usat per construir el nom de l'arxiu GARRLIC%!
%!
%! *VALORS DE RETORN*
%! 
%! * |GARRLiC_file_name: [string]| -
%!      Retorna un array de cel·les que contenen cadascuna, un missatge
%!      concret sobre el resultat de les revisions pertinents de les dades.
%!

    run('config_file.m')

% THIS FUNCTION PREPARES THE GRASP INPUT FILE FOR THE GARRLiC INVERSION, INCLUDING LIDAR SIGNAL AT 355, 532, AND 1064 NM 
% AND THE NEW WAVELENGHTS FROM CIMEL. 

%--------------------------------------------------------------------------------------------------------------------------
% ************************************ CREATING THE LENGTH OF THE INPUT VARIABLES *****************************************
%--------------------------------------------------------------------------------------------------------------------------

n380 = length(Radiancia380);
n440 = length(Radiancia440);
n500 = length(Radiancia500);
n675 = length(Radiancia675);
n870 = length(Radiancia870);
n1020 = length(Radiancia1020);
n1640 = length(Radiancia1640);
P380 = length(mPol380);
P440 = length(mPol440);
P500 = length(mPol500);
P675 = length(mPol675);
P870 = length(mPol870);
P1020 = length(mPol1020);
P1640 = length(mPol1640);
k = length(AOD440);
m = length(RangeIni);

for i=1:1:m
   Range(i)=RangeIni(m+1-i);
   LidarSignal355(i)=LS355(m+1-i);
   VolDep355(i)=VD355(m+1-i);
   LidarSignal532(i)=LS532(m+1-i);
   VolDep532(i)=VD532(m+1-i);
   LidarSignal1064(i)=LS1064(m+1-i);
end

NombreOutput = [NombreEntrada2,'_GARRLiC_D1P_L_VD.sdat'];

fullFileName = fullfile(outPath, NombreOutput);
fichero_GARRLiC = fopen(fullFileName ,'w');


%--------------------------------------------------------------------------------------------------------------------------
% **************************************** WRITING OF MEASUREMENT INFORMATION *********************************************
%--------------------------------------------------------------------------------------------------------------------------

fprintf(fichero_GARRLiC,'SDATA version 2.0/r\n');
fprintf(fichero_GARRLiC,'1 1 1 : NX NY NT/r\n');
fprintf(fichero_GARRLiC,'/r\n');
fprintf(fichero_GARRLiC,['1 ',NombreEntrada1,' %f  0 0 : NPIXELS TIMESTAMP HOBS NSURF IFGAS/r\n'],ground_height);
fprintf(fichero_GARRLiC,'1 1 1 0 0 %f %f %f 100.000000/r\n',longitude,latitude,ground_height);
fprintf(fichero_GARRLiC,'10 0.355 0.380 0.440 0.500 0.532 0.675 0.870 1.02 1.064 1.640/r\n');
fprintf(fichero_GARRLiC,'2 3 3 3 2 3 3 3 1 3/r\n');
fprintf(fichero_GARRLiC,'31 35 12 41 46 12 41 46 12 41 46 31 35 12 41 46 12 41 46 12 41 46 31 12 41 46/r\n');
fprintf(fichero_GARRLiC,'%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t%d/t/r\n',m,m,k,n380,P380,k,n440,P440,k,n500,P500,m,m,k,n675,P675,k,n870,P870,k,n1020,P1020,m,k,n1640,P1640);
fprintf(fichero_GARRLiC,'%f/t%f/t%f/t%f/t%f/t%f/t%f/t%f/t%f/t%f/r\n',0,SZA380,SZA440,SZA500,0,SZA675,SZA870,SZA1020,0,SZA1640);

%--------------------------------------------------------------------------------------------------------------------------
% ************************************** WRITING OF HEIGHTS AND ZENITAL ANGLES ********************************************
%--------------------------------------------------------------------------------------------------------------------------

% Height at 355 nm, m=size of RangeIni
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',Range(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Range(m));
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',Range(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Range(m));
% Zenith angles at 380 nm, n = size of randiance, P380 = size of degreed of polarization
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n380-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA380);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA380);
for i=1:1:P380-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA380);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA380);
% Zenith angles at 440 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n440-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA440);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA440);
for i=1:1:P440-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA440);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA440);
% Zenith angles at 500 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n500-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA500);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA500);
for i=1:1:P500-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA500);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA500);
% Height at 532 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',Range(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Range(m));
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',Range(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Range(m));
% Zenith angles at 675 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n675-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA675);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA675);
for i=1:1:P675-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA675);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA675);
% Zenith angles at 870 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n870-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA870);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA870);
for i=1:1:P870-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA870);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA870);
% Zenith angles at 1020 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n1020-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA1020);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA1020);
for i=1:1:P1020-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA1020);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA1020);
% Height at 1064 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',Range(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Range(m));
% Zenith angles at 1640 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n1640-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA1640);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA1640);
for i=1:1:P1640-1
    fprintf(fichero_GARRLiC,'%f/t',180-SZA1640);
end
fprintf(fichero_GARRLiC,'%f/r\n',180-SZA1640);

%--------------------------------------------------------------------------------------------------------------------------
% ********************************************** WRITING OF AZIMUTHAL ANGLES **********************************************
%--------------------------------------------------------------------------------------------------------------------------

% At 355 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',0);
end
fprintf(fichero_GARRLiC,'%f/r\n',0);
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',0);
end
fprintf(fichero_GARRLiC,'%f/r\n',0);
% At 380 nm
fprintf(fichero_GARRLiC,'%f/r\n',0);% AOD
for i=1:1:n380-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA380(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA380(n380));
for i=1:1:P380-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA380(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA380(P380));
% At 440 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n440-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA440(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA440(n440));
for i=1:1:P440-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA440(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA440(P440));
% At 500 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n500-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA500(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA500(n500));
for i=1:1:P500-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA500(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA500(P500));
% At 532 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',0);
end
fprintf(fichero_GARRLiC,'%f/r\n',0);
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',0);
end
fprintf(fichero_GARRLiC,'%f/r\n',0);
% At 675 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n675-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA675(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA675(n675));
for i=1:1:P675-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA675(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA675(P675));
% At 870 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n870-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA870(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA870(n870));
for i=1:1:P870-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA870(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA870(P870));
% At 1020 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n1020-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA1020(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA1020(n1020));
for i=1:1:P1020-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA1020(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA1020(P1020));
% At 1064 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%f/t',0);
end
fprintf(fichero_GARRLiC,'%f/r\n',0);
% At 1640 nm
fprintf(fichero_GARRLiC,'%f/r\n',0); %AOD
for i=1:1:n1640-1
    fprintf(fichero_GARRLiC,'%f/t',180+SAA1640(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+SAA1640(n1640));
for i=1:1:P1640-1
    fprintf(fichero_GARRLiC,'%f/t',180+PAA1640(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',180+PAA1640(P1640));

%--------------------------------------------------------------------------------------------------------------------------
% ************************************************ WRITING OF MEASUREMENTS ************************************************
%--------------------------------------------------------------------------------------------------------------------------

% Measurements at 355 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%e/t',LidarSignal355(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',LidarSignal355(m));
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%e/t',VolDep355(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',VolDep355(m));
% Measurements at 380 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD380); %AOD
for i=1:1:n380-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia380(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',Radiancia380(n380));
for i=1:1:P380-1
    fprintf(fichero_GARRLiC,'%f/t',mPol380(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',mPol380(P380));
% Measurements at 440 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD440); %AOD
for i=1:1:n440-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia440(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',Radiancia440(n440));
for i=1:1:P440-1
    fprintf(fichero_GARRLiC,'%f/t',mPol440(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',mPol440(P440));
% Measurements at 500 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD500); %AOD
for i=1:1:n500-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia500(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',Radiancia500(n500));
for i=1:1:P500-1
    fprintf(fichero_GARRLiC,'%f/t',mPol500(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',mPol500(P500));
% Measurements at 532 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%e/t',LidarSignal532(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',LidarSignal532(m));
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%e/t',VolDep532(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',VolDep532(m));
% Measurements at 675 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD675); %AOD
for i=1:1:n675-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia675(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Radiancia675(n675));
for i=1:1:P675-1
    fprintf(fichero_GARRLiC,'%f/t',mPol675(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',mPol675(P675));
% Measurements at 870 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD870); %AOD
for i=1:1:n870-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia870(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Radiancia870(n870));
for i=1:1:P870-1
    fprintf(fichero_GARRLiC,'%f/t',mPol870(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',mPol870(P870));
% Measurements at 1020 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD1020); %AOD
for i=1:1:n1020-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia1020(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Radiancia1020(n1020));
for i=1:1:P1020-1
    fprintf(fichero_GARRLiC,'%f/t',mPol1020(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',mPol1020(P1020));
% Measurements at 1064 nm
for i=1:1:m-1
    fprintf(fichero_GARRLiC,'%e/t',LidarSignal1064(i));
end
fprintf(fichero_GARRLiC,'%e/r\n',LidarSignal1064(m));
% Measurements at 1640 nm
fprintf(fichero_GARRLiC,'%f/r\n',AOD1640); %AOD
for i=1:1:n1640-1
    fprintf(fichero_GARRLiC,'%f/t',Radiancia1640(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',Radiancia1640(n1640));
for i=1:1:P1640-1
    fprintf(fichero_GARRLiC,'%f/t',mPol1640(i));
end
fprintf(fichero_GARRLiC,'%f/r\n',mPol1640(P1640));

%--------------------------------------------------------------------------------------------------------------------------
% ********************************************* WRITING OF CONTROL MECHANISMS *********************************************
%--------------------------------------------------------------------------------------------------------------------------

% You have to put two control rows that will be zero. Each row will have 26 zeros (number of value-SDATA 2.0 of the constant name).
fprintf(fichero_GARRLiC,'0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/r\n');
fprintf(fichero_GARRLiC,'0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/t0/r\n');

fclose(fichero_GARRLiC);
GARRLiC_file_name=NombreOutput;
end

