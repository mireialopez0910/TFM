function [ErrorType, ErrorMessage, ID_measure] = download(ID_measure, Auth, idType)
%%! [ErrorType, ErrorMessage, ID_measure] = download(ID_measure, Auth, idType)
%!
%%! Descripció
%!
%! La funció utilitza les credencials per connectar-se al servidor SCC i descarrega els
%! fitxers ELDA/ELPP segons s'indiquin als paràmetres d'entrada.
%! El fitxer esperat haurà d'estar en format .zip i una vegada descarregat es
%! descomprimeix al repositori corresponent (LIDAR).
%! Si l'estructura de directoris no està creada, la crearà la mateixa
%! funció per poder descomprimir el fitxer.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |ID_measure: [string]| - 
%!      Identificador de la mesura
%!
%! * |Auth: [structure]| -
%!      Variable de tipus estructura amb els valors d'autenticació (Auth) en cadascun dels seus camps:
%! 
%! *Camps de l'estructura:*
%!
%! - |Auth.GenericU:[string]| - Usuari per a la primera autenticació
%! 
%! - |Auth.GenericP:[string]| - Clau per a la primera autenticació
%! 
%! - |Auth.PersonalU:[string]| - Usuari per a la segona autenticació
%! 
%! - |Auth.PersonalP:[string]| - Clau per a la segona autenticació
%!
%! * |idType: [double vector]| - 
%!      Tipus de fitxer que es vol descarregar. Pot ser de tipus 'ELDA' o tipus 'ELPP'.
%!
%! *VALORS DE RETORN*
%!
%! * |ErrorType[int]| - 
%!      Torna 0 si es descarrega el fitxer correctament i -1 en cas
%!      de produir-se algun error.
%!
%! * |ErrorMessage[String]| - 
%!      Torna una descripció amb el resultat de la baixada.
%!
%! * |ID_measure[String]| - 
%!       Identificador de la mesura.

import matlab.net.http.*

run('config_file.m')

if idType=="ELDA"
    URL = [URLdownload_1, ID_measure, URLdownload_2ELDA];
else
    URL = [URLdownload_1, ID_measure, URLdownload_2ELPP];
end

ErrorType = 0;
ErrorMessage = '';
filename = [ID_measure, '.zip'];

try
    % Credenciales http se pasan como autorización
    AuthCred = matlab.net.base64encode([Auth.GenericU, ':', Auth.GenericP]);
    authorizationHeader = matlab.net.http.field.GenericField('Authorization', ['Basic ', AuthCred]);
    refererHeader = matlab.net.http.field.GenericField('Referer', CONFIG_SCCDomain);

    % Se manda una primer petición GET para poder obtener el CSRF token
    initialRequest = matlab.net.http.RequestMessage;
    initialRequest.Method = 'GET';
    initialRequest.Header = [initialRequest.Header,authorizationHeader];
    initialResponse = initialRequest.send(URL);    

    % Se extrae el CSRF token como cookie primero
    csrfCookieHeader = initialResponse.getFields('Set-Cookie');
    csrfCookie = char(csrfCookieHeader.Value);

    % Se divide la cookie para quedarse con la parte que nos interesa
    % que sera el token
    csrfCookieParts = strsplit(csrfCookie, '; ');
    csrfToken = extractAfter(csrfCookieParts{1}, '=');

    % Se comprueba si hemos obtenido el token correctamente
    if isempty(csrfToken)
        error('CSRF Token not found in the initial response.');
    end

    % Y ahora se crea otra petición con la que ya entraremos
    % dentro de la página para descargar
    loginRequest = matlab.net.http.RequestMessage;
    loginRequest.Method = 'POST';

    % Se añade el token a los headers
    csrfCookieField = matlab.net.http.field.CookieField(['csrftoken=' csrfToken]);
    loginRequest.Header = [loginRequest.Header,csrfCookieField, authorizationHeader, refererHeader];

    % Se selecciona un tipo de contenido y lo añadimos a headers
    % también
    contentType = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');
    loginRequest.Header = [loginRequest.Header, contentType];
    
    % Se añade al cuerpo de la petición el token, el usuario y la
    % contraseña de login en la página SCC
    bodyData = ['csrfmiddlewaretoken=' csrfToken '&username=' Auth.PersonalU '&password=' Auth.PersonalP];
    loginRequest.Body = bodyData;
    
    % Se manda la petición para entrar
    loginResponse = loginRequest.send(URL);
    
    disp(["body data:", length(loginResponse.Body.Data)])

    if length(loginResponse.Body.Data) > 1

        % Crea la estructura de directorios para los recursos LIDAR si no existe

        currentFolder = fileparts(mfilename('fullpath'));  
        URL_LIDAR = fullfile(currentFolder, CONFIG_LIDAR_folder);

        if ~exist(URL_LIDAR, 'dir')
            mkdir(URL_LIDAR);
            disp('Carpeta de recursos LIDAR creada.');
        else
            disp('La carpeta de recursos LIDAR ya existe, no se ha sobrescrito.');
        end

        % Se guarda el archivo lo extraemos y borramos el .zip que ya no se
        % necesita
        fid = fopen([fullfile(URL_LIDAR), filename], 'wb');
        fwrite(fid, loginResponse.Body.Data);
        fclose(fid);
        
        unzip([fullfile(URL_LIDAR), filename], fullfile(URL_LIDAR));
        delete([fullfile(URL_LIDAR), filename]);

        ErrorMessage = 'File downloaded correctly';
    else
        ErrorType = -1;
        ErrorMessage = 'File not found.'; 
    end
catch ME
    ErrorType = ME.identifier;
    ErrorMessage = ME.message; 

    if exist(filename, 'file')
        delete(filename);
    end
end
