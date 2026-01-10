function [minELPPAltitude, maxELPPAltitude, minVDAltitude, maxVDAltitude] = getValidEldaAltitude()

    minELPPAltitude =''; 
    maxELPPAltitude =''; 
    minVDAltitude ='';
    maxVDAltitude ='';

    [tfElda, cont_elda] = getFilteredTable('elda', 1);

    minELPPAltitude = [min(cell2mat( tfElda(1,:).elpp_altitude))];
    maxELPPAltitude = [max(cell2mat( tfElda(1,:).elpp_altitude))];

    minAltitudeCandidates = minELPPAltitude;
    maxAltitudeCandidates = maxELPPAltitude;

    for k=1 : height(tfElda)
        try
            VolDep = tfElda.volumedepolarization{k};
          
            if isnan(VolDep)
                logMessage('Volume Depolarizaton not found... Ignoring Elda altitude')
            else
                numericArray = cell2mat(cellfun(@(x) x(:), tfElda.elda_altitude(k,1), 'UniformOutput', false));
        
                minAltitudeCandidates = [minAltitudeCandidates, min(numericArray(:))];
                maxAltitudeCandidates = [maxAltitudeCandidates, max(numericArray(:))];
                
                logMessage(['Min. height for VD ', num2str(tfElda.wavelength(k,1)), ' is ', num2str(min(numericArray(:)))]);
                logMessage(['Max. height for VD ', num2str(tfElda.wavelength(k,1)), ' is ', num2str(max(numericArray(:)))]);     
    
                minVDAltitude = max(minAltitudeCandidates);
                maxVDAltitude = min(maxAltitudeCandidates);
            end
        catch
            logMessage('Volume Depolarizaton not found... Ignoring Elda altitude')
        end

    end
end
