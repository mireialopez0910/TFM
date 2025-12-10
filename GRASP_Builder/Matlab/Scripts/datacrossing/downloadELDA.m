function ErrorMessage = downloadELDA(ID_measure, myCred, idType)
    
import matlab.net.http.*

run('config_file.m')

if idType==1
    URL = [URLdownload_1, ID_measure, URLdownload_2ELDA];
else
        URL = [URLdownload_1, ID_measure, URLdownload_2ELPP];
end
ErrorType = 0;
ErrorMessage = '';
filename = [ID_measure, '.zip']; 

try
    % Credenciales http se pasan como autorización
    credentials = matlab.net.base64encode([myCred.login1, ':', myCred.passwd1]);
    authorizationHeader = matlab.net.http.field.GenericField('Authorization', ['Basic ', credentials]);
    refererHeader = matlab.net.http.field.GenericField('Referer', 'https://scc.imaa.cnr.it/');

    % Se manda una primer petición GET para poder obtener el CSRF token
    initialRequest = matlab.net.http.RequestMessage;
    initialRequest.Method = 'GET';
    initialRequest.Header = [initialRequest.Header,authorizationHeader];
    initialResponse = initialRequest.send(URL);    

    % Se extrae el CSRF token como cookie primero
    csrfCookieHeader = initialResponse.getFields('Set-Cookie');
    csrfCookie = char(csrfCookieHeader.Value);

    % Se dividela cookie para quedarse con la parte que nos interesa
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
    bodyData = ['csrfmiddlewaretoken=' csrfToken '&username=' myCred.login2 '&password=' myCred.passwd2];
    loginRequest.Body = bodyData;
    
    % Se manda la petición para entrar
    loginResponse = loginRequest.send(URL);
    
    disp(["body data:", length(loginResponse.Body.Data)])

    if length(loginResponse.Body.Data) > 1

        % Se guarda el archivo lo extraemos y borramos el .zip que ya no se
        % necesita
        fid = fopen(filename, 'wb');
        fwrite(fid, loginResponse.Body.Data);
        fclose(fid);
        
        unzip(['./', filename], './Medidas/')
        delete(['./', filename]);

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
