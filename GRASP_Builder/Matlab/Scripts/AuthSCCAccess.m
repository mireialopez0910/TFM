function [isValid, message] = AuthSCCAccess(Auth)
%%! [isValid, message] = AuthSCCAccess(Auth)
%%! Descripció
%!
%! Envia les credencials d'accés a la plataforma SCC utilitzant una doble autenticació
%! per obtenir un accés vàlid. La primera autenticació es realitza a nivell de servidor
%! i la segona valida l'accés a les pàgines que requereixen un token de sessió vàlid.
%!
%! El paràmetre d'autenticació (Auth) ha de ser de tipus estructura i
%! els camps de tipus cadena (Auth.GenericU, Auth.GenericP, Auth.PersonalU, Auth.PersonalP)
%! 
%! *PARÀMETRES D'ENTRADA*
%!
%! * |Auth: [structure]| -
%!      variable de tipus estructura amb els valors d'autenticació (Auth) en cadascun dels seus camps:
%! 
%! *Camps de l'estructura:*
%!
%! * |Auth.GenericU:[string]| - Usuari per a la primera autenticació
%! * |Auth.GenericP:[string]| - Clau per a la primera autenticació
%! * |Auth.PersonalU:[string]| - Usuari per a la segona autenticació
%! * |Auth.PersonalP:[string]| - Clau per a la segona autenticació
%! 
%! *VALORS DE RETORN*
%!
%! |[isValid, message]|
%!
%! * |isValid:[boolean]| -
%!      Retorna |true| si les credencials d'autenticació són correctes i |false| en cas contrari.
%!
%! * |message:[string]| -
%!      Missatge explicatiu sobre l'estat de l'autenticació.
%!


    run('config_file.m')
    URL = [URLdownload_1, '20221006brc4306', URLdownload_2ELDA];
    isValid = false;
    statusCode = '';
    token = '';
    message = '';

    % Credenciales http se pasan como autorización
    AuthCred = matlab.net.base64encode([Auth.GenericU, ':', Auth.GenericP]);
    authorizationHeader = matlab.net.http.field.GenericField('Authorization', ['Basic ', AuthCred]);
    refererHeader = matlab.net.http.field.GenericField('Referer', CONFIG_SCCDomain);


    % Se manda una primer petición GET para poder obtener el CSRF token
    initialRequest = matlab.net.http.RequestMessage;
    initialRequest.Method = 'GET';
    initialRequest.Header = [initialRequest.Header,authorizationHeader];
    initialResponse = initialRequest.send(URL);    

    if strcmpi(initialResponse.StatusCode, 'OK')

        % Se extrae el CSRF token como cookie primero
        csrfCookieHeader = initialResponse.getFields('Set-Cookie');
        csrfCookie = char(csrfCookieHeader.Value);
    
        % Se divide la cookie para quedarse con la parte que nos interesa
        % que sera el token
        csrfCookieParts = strsplit(csrfCookie, '; ');
        csrfToken = extractAfter(csrfCookieParts{1}, '=');

        if ~isempty(csrfToken)
            token = csrfToken;
            isValid = true;
            message = 'Logged successfully with a valid token.';


            


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
            
            if  length(loginResponse.Body.Data) > 1
                isValid = true;
                message = 'Logged successfully.';
            else
                message = 'Invalid personal user / password';
                isValid = false;
            end
        else
            message = 'Logged successfully but CSRF Token not found.';
            isValid = false;
        end
    else
        message = 'Invalid generic user / password';
        isValid = false;
    end
end