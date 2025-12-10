function specificFolders = findSpecificFolders(selectedIdMeasure)
%%! findSpecificFolders(IdMeasure)
%%! Descripció
%!
%! Indicant un ID de mesura (measureID), retorna la llista de subcarpetes on 
%! es troben els fitxers de cada possible configuració disponible per crear 
%! els seus gràfics corresponents (plot).
%!
%! L'estructura és:
%!
%! [MeasureID] -> [config_type] - [MeasureID] - [Min Height] - [Max. Height]
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |selectedIdMeasure: [string]| -
%!      Identificador de la mesura que s'utilitzarà per identificar les carpetes que contenen cada configuració.
%!
%! *VALORS DE RETORN*
%!
%! * |specificFolders:[string[]]| -
%!      Array de cadenes amb els noms de les subcarpetes de cada configuració.
%!



    currentFolder = fileparts(mfilename('fullpath'));
    run('config_file.m');
    %parentFolder = fileparts(currentFolder);
    measureIDFolder = fullfile(fullfile( currentFolder, CONFIG_output, selectedIdMeasure) );
    
    disp( measureIDFolder);


    files = dir(measureIDFolder);

    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    subFolders = subFolders(~ismember({subFolders.name}, {'.', '..'}));
    prefixList = {'D1_L', 'D1_L_VD', 'D1P_L', 'D1P_L_VD'};
    specificFolders = {};
    for k = 1:length(subFolders)
        folderName = subFolders(k).name;

        disp(folderName);

        if any(startsWith(folderName, prefixList))
            specificFolders{end+1} = folderName; %#ok<AGROW>
        end
    end
end