function [is_D1_L, is_D1P_L, is_D1_L_VD, is_D1P_L_VD, message] = checkSendDataConfigs()
%%! [boolean, boolean, boolean, boolean] = checkSendDataConfigs()
%%! DESCRIPCIÓ
%!
%! Analitza les dades de les taules ELDA, ELPP, ALL, ALM, ALP, LEV15 per
%! definir les configuracions vàlides per a generar els fitxers .SDAT i .MAT que s'han d'enviar a GRASP.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * No es requereixen paràmetres d'entrada
%!
%! *VALORS DE RETORN*
%!
%! [is_D1_L, is_D1P_L, is_D1_L_VD, is_D1P_L_VD]
%!
%! * |is_D1_L: [boolean]| -
%!      indica si la configuració D1_L (dades tant del LIDAR com del fotòmetre
%!      sense despolarització) estan disponible.
%!
%! * |is_D1P_L: [boolean]| -
%!      indica si la configuració D1P_L està disponible
%!      (dades del LIDAR sense despolarització i fotòmetre amb despolarització)
%!
%! * |is_D1_L_VD: [boolean]| -
%!      indica si la configuració D1_L_VD està disponible 
%!      (dades del LIDAR amb despolarització i del fotòmetre sense despolarització)
%!
%! * |is_D1P_L_VD: [boolean]| -
%!      indica si la configuració D1P_L_DVD està disponible
%!      (dades tant del LIDAR com del fotòmetre amb despolarització)
%! 
%! * |message: [cell[string]]| -
%!      Retorna un array de cel·les que contenen cadascuna, un missatge
%!      concret sobre el resultat de les revisions pertinents de les dades.
%!
%%! Com funciona
%! Per defecte totes les configuracions estan disponibles per utilitzar i 
%! després de comprovar cada conjunt de condicions per a cada configuració
%! s'actualitza amb «"false"» si no és adequat.
%!
%! *Important:* Aquesta funció accedeix a les taules filtrades al Workspace
%! i analitza les dades disponibles.
%!
%!
%%! Taules analitzades: 
%!
%! * Taula Elda/Elpp (obté el nom usant la funció |getWSTNByType()| )
%!
%! * Taula OAD (tfLev15_1) 
%!
%! * Taula 'ALL'
%!
%! * Taula 'ALM' 
%!
%! * Taula 'ALP' 
%!

    is_D1_L = "true";
    is_D1_L_VD = "true";
    is_D1P_L = "true";
    is_D1P_L_VD = "true";


    

    %%! Dades mínimes requerides
     %! 
     %! *Dades en rangs filtrats*:
     %! Consulta la taula AOD (tfLev15_1) i Almucantar (ALM).
     %! Si falta una de les dues taules TOTES les configuracions canvien a
     %! desactivat (estat fals)
     %!
     %! *Dades específiques requerides en taules*: 
     %! Addicionalment, es revisen determinades dades que han d'existir a les taules ALM i ALP
     %! per poder generar el fitxer SDAT en terminades configuracions.
     %!
     %! * *getALMData()*
     %! Comprova que hi hagi dades a 'Nominal_Wavelength(nm)' per a les
     %! longituds d'ona: 1640, 1020, 870, 675, 500, 440, 380
     %!
     %! * *getALPData()*
     %! Comprova que hi hagi dades a 'Nominal_Wavelength(nm)' per a les
     %! longituds d'ona: 1020, 870, 675, 500, 440, 380
     %!

    T1 = evalin('base','tfLev15_1');
    T2 = evalin('base','tfAlm');
    T3 = evalin('base','tfAll');
    
    [isALMData, message_ALM]= getALMData();

    if height(T1) == 0 || ~isALMData || height(T3) == 0
        is_D1_L = "false";
        is_D1_L_VD = "false";
        is_D1P_L = "false";
        is_D1P_L_VD = "false";
    end




    %%! Taula 'ALP'
    %! Comprova les dades de polarització del fotòmetre.
    %! si la taula 'ALP' no està disponible, les configuracions D1P_L i D1P_L_VD es desactivaran
    %!

    [isALPData, message_ALP]= getALPData();

    if ~isALPData
        is_D1P_L = "false";
        is_D1P_L_VD = "false";
    end


    

    %%! Taula 'ELDA/ELPP'
    %! Comprova les dades de la despolarització de volum LIDAR (configuració VD).
    %! si la taula "ELDA/ELPP" no està disponible, les configuracions D1_L_VD i D1P_L_VD es desactivaran
    %!
    elda_name = getWSTNByType('elda').table_name{1};
    tEldaElpp = evalin('base', elda_name);
        
    count_1064 = height(tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :));
    count_0532 = height(tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :));
    count_0355 = height(tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :));

    if count_1064 > 0
        VD_1064_ELPP = tEldaElpp( contains(tEldaElpp.fileName, '_b1064_'), :).volumedepolarization;
    
        if isnan(cell2mat(VD_1064_ELPP))
            status_1064 = 1;
            message_1064 = 'VD not found in wavelength 1064 (no values found)';
        elseif all(isnan(cell2mat(VD_1064_ELPP)))
            status_1064 = 1;
            message_1064 = 'VD not found in wavelength 1064 (nan values found only)';
        else
            status_1064 = 2;
            message_1064 = 'VD found in wavelength 1064';
        end
    
    else
        status_1064 = 0;
        message_1064 = 'Not found wavelength 1064';
    end

    logMessage(['Status 0532: ',num2str(status_1064)]);
    logMessage(message_1064);




    if count_0532 > 0
        VD_0532_ELPP = tEldaElpp( contains(tEldaElpp.fileName, '_b0532_'), :).volumedepolarization;
    
        if isnan(cell2mat(VD_0532_ELPP))
            status_0532 = 1;
        elseif all(isnan(cell2mat(VD_0532_ELPP)))
            status_0532 = 1;
        else
            status_0532 = 2;
        end
    else
        status_0532 = 0;
    end

    logMessage(['Status 0532: ',num2str(status_0532)]);


    if count_0355 > 0
        VD_0355_ELPP = tEldaElpp( contains(tEldaElpp.fileName, '_b0355_'), :).volumedepolarization;
    
        if isnan(cell2mat(VD_0355_ELPP))
            status_0355 = 1;
        elseif all(isnan(cell2mat(VD_0355_ELPP)))
            status_0355 = 1;
        else
            status_0355 = 2;
        end
    
    else
        status_0355 = 0;
    end

    logMessage(['Status 0355: ',num2str(status_0355)]);

    if(status_0532 < 2 || status_0355 < 2)
        is_D1_L_VD = "false";
        is_D1P_L_VD = "false";
    end

    message = [message_ALM, message_ALP];
end