function [statusWaveLength, message_waveLength , status_1064, message_1064, status_0532, message_0532, status_0355, message_0355] = checkElda()

    elda_name = getWSTNByType('elda').table_name{1};
    tEldaElpp = evalin('base', elda_name);
        
    count_1064 = height(tEldaElpp( contains(tEldaElpp.fileName, '_1064_'), :));
    count_0532 = height(tEldaElpp( contains(tEldaElpp.fileName, '_0532_'), :));
    count_0355 = height(tEldaElpp( contains(tEldaElpp.fileName, '_0354_'), :));
    count_0354 = height(tEldaElpp( contains(tEldaElpp.fileName, '_0354_'), :));

    %%% Check Elda & Elpp wavelength avaliability
    %%% Status 1 = correct / 0 = non verified / -1 = missing elda / -2 = missing elpp
    
    statusWaveLength = 0;
    message_waveLength = 'Wavelength not verified';
    
    status_1064 = 0;
    message_1064 = 'Wavelength 1064 not verified';

    status_0532 = 0;
    message_0532 = 'Wavelength 0532 not verified';

    status_0355 = 0;
    message_0355 = 'Wavelength 0355 not verified';

    

   % Comprobamos los ELDAs y ELPP para 1064
   if count_1064 > 0
        count_ELPP_altitude = height( tEldaElpp( contains(tEldaElpp.fileName, '_1064_'), :).elpp_altitude );
        if count_ELPP_altitude > 0
            status_1064 = 1;
            message_1064 = 'Wavelength 1064: verified correctly';
        else
            status_1064 = -2;
            message_1064 = 'Wavelength 1064: Missing ELPP';
        end
   else
       status_1064 = -1;
   end

   if count_0532 > 0
        count_ELPP_altitude = height( tEldaElpp( contains(tEldaElpp.fileName, '_0532_'), :).elpp_altitude);
        if count_ELPP_altitude > 0
            status_0532 = 1;
            message_0532 = 'Wavelength 532: verified correctly';
        else
            status_0532 = -2;
            message_0532 = 'Wavelength 532: Missing ELPP';
        end
    else
        status_0532 = -1;
    end

    if count_0355 > 0
        count_ELPP_altitude = height(tEldaElpp( contains(tEldaElpp.fileName, '_0354_'), :).elpp_altitude);
        if count_ELPP_altitude > 0
            status_0355 = 1;
            message_0355 = 'Wavelength 355: verified correctly';
        else
            status_0355 = -2;
            message_0355 = 'Wavelength 355: Missing ELPP';
        end
    else
        if count_0354>0
            count_ELPP_altitude = height(tEldaElpp( contains(tEldaElpp.fileName, '_0354_'), :).elpp_altitude);
            if count_ELPP_altitude > 0
                status_0355 = 1;
                message_0355 = 'Wavelength 355: verified correctly';
            else
                status_0355 = -2;
                message_0355 = 'Wavelength 355: Missing ELPP';
            end
        else
            status_0355 = -1;
            message_0355 = 'Missing ELDA 355 wavelength. Please, check';
        end
    end

    if (status_1064 == 1) && (status_0532 == 1) && (status_0355 ==1)
        statusWaveLength = 1;
        message_waveLength = 'All wavelength verified correctly';
    else
        statusWaveLength = -1;
        message_waveLength = 'Missing some wavelength';
    end
end

