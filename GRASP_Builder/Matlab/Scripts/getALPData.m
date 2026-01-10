function [isValid, message] = getALPData()
%%! [isValid, message] = getALPData()
%%! DESCRIPCIÓ
%!
%! Analitza les dades de la taula ALP i comprova que hi hagi dades a 'Nominal_Wavelength(nm)' per a les
%! longituds d'ona: 1020, 870, 675, 500, 440, 380
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * No es requereixen paràmetres d'entrada
%!
%!
%! *VALORS DE RETORN*
%!
%! * |isValid: [boolean]| -
%!      Torna 'true' si conté totes les dades requerides per poder aplicar
%!      la configuració i en cas de contrari retorna un 'false' 
%! 
%! * |message: [cell[string]]| -
%!      Retorna un array de cel·les que contenen cadascuna, un missatge
%!      concret sobre el resultat de les revisions pertinents de les dades.
%!
    isValid = true;
    message = {'Nominal_Wavelength(nm) in ALP table, found correctly'};

    try
        
        T4_ALP = evalin('base','tfAlp');

        if( height(T4_ALP) > 0) 

            nwl = T4_ALP.('Nominal_Wavelength(nm)');

            if isempty( find(nwl==1020, 1) )
                isValid = false; message = 'ERROR: [ALP] Not found Nominal_Wavelength(nm) for 1020 wavelength';
            end
    
            if isempty( find(nwl==870, 1) )
                isValid = false; message = 'ERROR: [ALP] Not found Nominal_Wavelength(nm) for 870 wavelength';
            end
    
            if isempty( find(nwl==675, 1) )
                isValid = false; message = 'ERROR: [ALP] Not found Nominal_Wavelength(nm) for 675 wavelength';
            end
            
            if isempty( find(nwl==500, 1) )
                isValid = false; message = 'ERROR: [ALP] Not found Nominal_Wavelength(nm) for 500 wavelength';
            end
            
            if isempty( find(nwl==440, 1) )
                isValid = false; message = 'ERROR: [ALP] Not found Nominal_Wavelength(nm) for 440 wavelength';
            end      

            if isempty( find(nwl==380, 1) )
                isValid = false; message = 'ERROR: [ALP] Not found Nominal_Wavelength(nm) for 380 wavelength';
            end      

            if(isValid)
                message = '[ALP] Nominal_Wavelength(nm) in ALP table, found correctly';
            end
    
        else
            isValid = false;
            message = {'ERROR: [ALP] Data not found for ALP'};
        end

    catch ME
        isValid=false;
        message= ['Error: ', ME.message];
    end
    
    % logMessage(message);
end

