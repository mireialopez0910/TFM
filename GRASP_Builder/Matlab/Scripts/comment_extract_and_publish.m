function comment_extract_and_publish(path_to_file)
%%! comment_extract_and_publish(path_to_file)
%%! DESCRIPCIÓ
%!
%! Crea els fitxers de documentació tècnica extraient els comentaris
%! de cada fitxer de codi de l'aplicació. Els comentaris que es
%! vulguin publicar han d'incloure un tancament d'exclamació despulles del
%! caràcter de comentari '%' per diferenciar-los dels comentaris
%! informàtics del codi que no han de ser publicats.
%!
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |path_to_file: [string]| -
%! Ruta al fitxer del qual es vol crear la documentació
%!
%! *VALORS RETORNATS*
%!
%! * No torna cap valor
%!

    % Define las rutas absolutas
    raiz_proyecto = fileparts(mfilename('fullpath'));  % Obtiene el directorio del script actual
    carpeta_docs = fullfile(raiz_proyecto, 'documentation', 'docs', 'functions');
    carpeta_tmp = fullfile(raiz_proyecto, 'documentation', 'tmp');

    % Verifica si el archivo existe
    if ~exist(path_to_file, 'file')
        error('El archivo no existe: %s', path_to_file);
    end
    
    % Crea la carpeta 'docs' si no existe
    if ~exist(carpeta_docs, 'dir')
        mkdir(carpeta_docs);
    end

    % Crea la carpeta 'tmp' si no existe
    if ~exist(carpeta_tmp, 'dir')
        mkdir(carpeta_tmp);
    end

    % Abre el archivo de código
    fid = fopen(path_to_file, 'r');
    
    % Si no puede abrir el archivo, lanza un error
    if fid == -1
        error('No se pudo abrir el archivo: %s', path_to_file);
    end
    
    % Crea un nombre para el archivo de salida (comentarios) en la carpeta 'docs'
    [~, nombre, ~] = fileparts(path_to_file);
    archivo_doc = fullfile(carpeta_tmp, [nombre, '_doc.m']);
    fid_out = fopen(archivo_doc, 'w');
    
    % Lee y extrae solo los comentarios
    % Solo incouye los comentarios marcados para ser publicados '%|'
    while ~feof(fid)
        linea = strtrim(fgetl(fid));
        if startsWith(linea, '%') && contains(linea, '%!')
            linea = strrep(linea, '%!', '%');

            % Reemplaza carácteres que no interpreta correctamente: 'à' 
            linea = strrep(linea, 'à', '&agrave;');

            fprintf(fid_out, '%s\n', linea);
        end
    end
    
    % Cierra los archivos
    fclose(fid);
    fclose(fid_out);
    
    % Publica el archivo de comentarios en formato PDF en la carpeta 'docs'
    opts.format = 'html';
    opts.outputDir = carpeta_docs;  % Especifica el directorio de salida para el PDF
        
    try
    %    pause(1);
        publish(archivo_doc, opts);
    catch ME
        disp('Error al publicar el archivo:');
        disp(ME.message);
    end
   
    
    disp(['Documentation extracted and published y publicados en PDF en: ', carpeta_docs]);
end