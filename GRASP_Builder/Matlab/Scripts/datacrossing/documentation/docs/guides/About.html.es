<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>DataCrossing Tutorial</title>
<meta name="generator" content="MATLAB 24.1">
<link rel="schema.DC" href="http://purl.org/dc/elements/1.1/">
<meta name="DC.date" content="2024-09-24">
<meta name="DC.source" content="AuthSCCAccess_doc.m">
<style type="text/css">
html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td{margin:0;padding:0;border:0;outline:0;font-size:100%;vertical-align:baseline;background:transparent}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:'';content:none}:focus{outine:0}ins{text-decoration:none}del{text-decoration:line-through}table{border-collapse:collapse;border-spacing:0}

html { min-height:100%; margin-bottom:1px; }
html body { height:100%; margin:0px; font-family:Arial, Helvetica, sans-serif; font-size:10px; color:#000; line-height:140%; background:#fff none; overflow-y:scroll; }
html body td { vertical-align:top; text-align:left; }

h1 { padding:0px; margin:0px 0px 25px; font-family:Arial, Helvetica, sans-serif; font-size:1.5em; color:#d55000; line-height:100%; font-weight:normal; }
h2 { padding:0px; margin:0px 0px 8px; font-family:Arial, Helvetica, sans-serif; font-size:1.2em; color:#000; font-weight:bold; line-height:140%; border-bottom:1px solid #d6d4d4; display:block; }
h3 { padding:0px; margin:0px 0px 5px; font-family:Arial, Helvetica, sans-serif; font-size:1.1em; color:#000; font-weight:bold; line-height:140%; }

a { color:#005fce; text-decoration:none; }
a:hover { color:#005fce; text-decoration:underline; }
a:visited { color:#004aa0; text-decoration:none; }

p { padding:0px; margin:0px 0px 20px; }
img { padding:0px; margin:0px 0px 20px; border:none; }
p img, pre img, tt img, li img, h1 img, h2 img { margin-bottom:0px; }

ul { padding:0px; margin:0px 0px 20px 23px; list-style:square; }
ul li { padding:0px; margin:0px 0px 7px 0px; }
ul li ul { padding:5px 0px 0px; margin:0px 0px 7px 23px; }
ul li ol li { list-style:decimal; }
ol { padding:0px; margin:0px 0px 20px 0px; list-style:decimal; }
ol li { padding:0px; margin:0px 0px 7px 23px; list-style-type:decimal; }
ol li ol { padding:5px 0px 0px; margin:0px 0px 7px 0px; }
ol li ol li { list-style-type:lower-alpha; }
ol li ul { padding-top:7px; }
ol li ul li { list-style:square; }

.content { font-size:1.2em; line-height:140%; padding: 20px; }

pre, code { font-size:12px; }
tt { font-size: 1.2em; }
pre { margin:0px 0px 20px; }
pre.codeinput { padding:10px; border:1px solid #d3d3d3; background:#f7f7f7; }
pre.codeoutput { padding:10px 11px; margin:0px 0px 20px; color:#4c4c4c; }
pre.error { color:red; }

@media print { pre.codeinput, pre.codeoutput { word-wrap:break-word; width:100%; } }

span.keyword { color:#0000FF }
span.comment { color:#228B22 }
span.string { color:#A020F0 }
span.untermstring { color:#B20000 }
span.syscmd { color:#B28C00 }
span.typesection { color:#A0522D }

.footer { width:auto; padding:10px 0px; margin:25px 0px 0px; border-top:1px dotted #878787; font-size:0.8em; line-height:140%; font-style:italic; color:#878787; text-align:left; float:none; }
.footer p { margin:0px; }
.footer a { color:#878787; }
.footer a:hover { color:#878787; text-decoration:underline; }
.footer a:visited { color:#878787; }

table th { padding:7px 5px; text-align:left; vertical-align:middle; border: 1px solid #d6d4d4; font-weight:bold; }
table td { padding:7px 5px; text-align:left; vertical-align:top; border:1px solid #d6d4d4; }





  </style>
</head>
<body>
<div class="content">
<h1>Acerca de DataCrossing</h1>
<!--introduction-->
<!--/introduction-->
<h2>Contenidos</h2>
<div>
	<ul>
		<li><a href="#1">Introducción</a></li>
		<li><a href="#2">Requisitos previos</a></li>
		<li><a href="#3">Flujo de trabajo</a></li>
		<li><a href="#4">Interfaz de usuario</a></li>
		<li><a href="#5">Conclusión</a></li>
	</ul>
</div>
<h2 id="1">Introducción</h2>
<h3>Acerca de DataCrossing</h3>
<p>DataCrossing es una herramienta de filtrado y unificación de datos sobre aerosoles obtenidos a partir de observaciones de teledetección proveniente de diferentes plataformas para su preparación y envío a GRASP  (Generalized Retrieval of Aerosol and Surface Properties).</p>
<p>Este algoritmo (GRASP) de recuperación de aerosoles de alta precisión procesa las propiedades de reflectancia de los aerosoles y de la superficie terrestre devolviendo toda la información para que DataCrossing complemente el modelo de parámetros analizados y genere un conjunto de gráficas que representan esta información.</p>
<p>En definitiva, el uso intuitivo de fácil configuración y su gestión de errores, la convierten en una herramienta segura y útil para realizar con rapidez los análisis de las propiedades de los aerosoles.</p>

<h2 id="2">Requisitos previos</h2>
<h3>Datos de entrada</h3>
<p>El sistema integra un repositorio AERONET con la Información sobre los aerosoles de Aeronet (AOD, ALM, ALP, ALL). Los ficheros se encuentran ubicados en una carpeta específica a tal efecto en: <root_project>/repository/AERONET/</p>
<p>Los ficheros pueden ser actualizados o reemplazados bajo el criterio del usuario. por defecto dispone de los siguientes:</p>

<ul>
<li>
<strong>AOD (Aerosol Optical Depth):</strong> Contiene los datos de la profundidad óptica de los aerosoles. Mide la cantidad de aerosoles en la atmósfera y su capacidad para bloquear la radiación solar, proporcionando información clave sobre la calidad del aire.<br/>
<tt>Version 3: AOD Level 1.5</tt>
</li>

<li>
<strong>ALM (Almucantar):</strong> Recoge medidas del cielo a diferentes ángulos de elevación, permitiendo el análisis detallado de las propiedades de los aerosoles, como tamaño y forma, mediante el uso de modelos de dispersión de luz.<br/>
<tt>Version 3: Raw Almucantar</tt>

</li>

<li>
<strong>ALP (Almucantar Level 2.0):</strong> Similar a los ficheros ALM, pero contiene datos validados y procesados con mayor precisión (nivel 2.0). Además, incluye información sobre la polarización de la luz registrada por los fotómetros, lo que permite un análisis más detallado de las propiedades ópticas de los aerosoles.<br/>
<tt>Version 3: Raw Polarized Almucantar (with degree of polarization)</tt>

</li>

<li>
<strong>ALL:</strong> Es un fichero combinado que incluye toda la información disponible de AOD, ALM y otros tipos de medidas, proporcionando un conjunto de datos más completo y detallado para estudios integrales.<br/>
<tt>Version 3: Almucantar Level 1.5 Inversion</tt>

</li>
</ul>

<p>Puedes consulta la morfología exacta de cada fichero en estas páginas:</p>
<ul>
	<li>Estructura de columnas de AOD (Aerosol Optical Depth)</li>
	<li>Estructura de columnas de ALM (Almucantar)</li>
	<li>Estructura de columnas de ALP (Almucantar Level 2.0)</li>
	<li>Estructura de columnas de ALL</li>
</ul>

<h3>Configuración necesaria</h3>
<p><strong>Credenciales SCC:</strong> El sistema está preconfigurado para conectarse al servidor SCC (Single Calculus Chain) para obtener los datos de las medidas del LIDAR. Sin embargo, el usuario debe disponer de las correspondientes credenciales de acceso. El sistema SCC requiere de dos juegos de autenticación:</p>
<ul>
<li><strong>Generic SCC Authentication</strong> permite el acceder a la primera capa de seguridad del servidor.</li>
<li><strong>Personal SCC Authentication</strong> genera un token de sesión para poder acceder a las zonas autenticadas bajo este rol que incluye la solicitud y descarga de medidas LIDAR.</li>
</ul>
<p>
<p><strong>SystemIDs:</strong> Lista de IDs definida en el fichero de configuración <span class="typesection">configuraciones_SCC.xlsx</span> ubicado en <span class="typesection"><root_project>/config/</span></p>
<p>Esta lista no contiene cabecera ni metadatos y la aplicación asume que todos los IDs se encuentran en la primera columna utilizando una fila por ID<br/>
<img width="100%" height="auto" src="./systemId.jpg">
</p>

<p>
<p><strong>Database:</strong> Un fichero en formato CSV ubicado en <span class="typesection"><root_project>/database/</span> que contiene todos los <span class="typesection">MeasuresID</span> con sus correspondientes SystemIDs. La aplicación cruza los <span class="typesection">MeasuresID</span> cuyos <span class="typesection">SystemID</span> coinciden con los proporcionados en la configuración para crear una lista filtrada de Medidas disponibles.<br>
<img width="60%" height="auto" src="./Database.jpg">







<h2 id="3">Flujo de trabajo</h2>

<p>
<h3>Cargar datos</h3>
Se debe asegurar que están disponibles los ficheros de Aeronet requeridos para que puedan cargarse en el espacio de trabajo (WorkSpace) y seleccionar la base de datos de <span class="typesection">MeasuresID</span> para cargarla también.
</p>

<p>
<h3>Procesamiento de datos</h3>
Los datos de AERONET y LIDAR son filtrados por fechas creando las correspondientes tablas filtradas en el espacio de trabajo (WorkSpace). Se selecciona una de las cuatro configuraciones disponibles (cuando las haya) y se ajustan los límites de altura usados.
</p>

<p>
<h3>Resultados</h3>
Se generan dos archivos de datos con los resultados de las operaciones efectuadas en la ejecución de las configuraciones.</p>
<p>El archivo .MAT incorpora datos sobre los parámetros utilizados en los cálculos para generar el SDAT y será complementado con más información en el módulo de ploteo. La estructura de nombres de estos archivos es:

<ul>
<li><span class="typesection">GRASP_&lt;location&gt;_&lt;measureID&gt;_&lt;config&gt;.mat</span></li>
<li><span class="typesection">&lt;measureID&gt;_GARRLIC_&lt;config&gt;.sdat</span></li>
</ul>
</p>
<p>Adicionalmente todos los datos filtrados de las tablas de recursos pueden localizarse y consultarse en el espacio de trabajo (WorkSpace).</p>
Fácilmente identificables por el prefijo <span class="typesection">‘ft_&lt;tabla&gt;</span> (Filtered Table)</p>





<h2 id="4">Interfaz de usuario</h2>
<p>
<h3>Componentes principales</h3>
<p/>
<ul>
<li><strong>Autenticación SCC:</strong> Módulo de autenticación que permite introducir los dos pares de usuario/contraseña para poder conectarse al sistema SCC.</li>
<li><strong>Prebuild GRASP:</strong> Módulo principal donde se definen las configuraciones y otros detalles de los datos que se quieren procesar para enviarlos a GRASP.</li>
<li><strong>GRASP Plotting:</strong> Módulo responsable de procesar el fichero de salida de GRASP, para completar el fichero MAT creado en el módulo principal y crear un conjunto de gráficas que ilustran la información obtenida en los procesos anteriores..</li>
<li><strong>Ayuda:</strong> Módulo de ayuda que incluye información relativa a la aplicación. Incluye un Acerca de DataCrossing con información detallada de su funcionamiento y documentación relativa a las funciones más relevantes..</li>
</ul>
</p>


<p>
<h3>Acciones principales</h3>
<p/>
A continuación se enumeran las acciones típicas que se deben realizar para ejecutar la aplicación correctamente.

<ul>
	<li>Introducción de credenciales Generic SCC / Personal SCC</li>
	<li>Selección de base datos de MeasuresID</li>
	<li>Filtrado de fechas</li>
	<li>Selección de la medida (Measure ID) y descarga de datos LIDAR</li>
	<li>Previsualización de la medida en el visor</li>
	<li>Selección de los rangos mínimos y máximos de altura
		<ul><li>Opcionalmente: Criterio de altura para ELPP o VD</li></ul>
	</li>
	<li>Selección de la configuración de datos (LIDAR + Fotómetro)
		<ul><li>Mostrar gráficas durante la creación de la configuración</li></ul>
	</li>
	<li>Creación de ficheros SDAT y MAT para GRASP</li>
	<li><span class="untermstring">En GRASP:</span> Procesado del fichero SDAT</li>
	<li><span class="untermstring">En GRASP:</span> Generación del fichero de salida (Out.txt)</li>
	<li>Selección de MeauseID y Configuración para la creación de gráficas y complementación del fichero MAT con información adicional.</li>
	<li>Visualizar las gráficas en el visor.</li>
</ul>
</p>






<h2 id="5">Conclusión</h2>
<p>
<h3>Beneficios clave</h3>
<p/>
<ul>
	<li>Uso intuitivo al configurarse y ejecutar todo el proceso en una aplicación gráfica.</li>
	<li>Seguridad al minimizar errores evitando la entrada de datos manuales.</li>
	<li>Robustez al eliminar el uso de scripts hardcodeados</li>
	<li>Eficiencia al tratarse de una solución flexible que informa de cualquier anomalía o falta de datos (NaN en valores de alturas, falta de ficheros claves o datos en el filtrado, etc.</li>
	<li>Escalable al ser diseñada para adaptarse a diferentes localizaciones.</li>
</ul>
</p>

<p>
<h3>Siguientes pasos</h3>
<p/>
<ul>
	<li>
		<p>Carga bajo demanda de los recursos de Aeronet: Sustitución de la carga de recursos con ficheros locales completos de Aeronet en favor de un modelo dinámico basado en el filtro de las mediciones utilizando la API de la propia fuente.</p>
		<p>Ejemplo: <a target="_new" href="https://aeronet.gsfc.nasa.gov/cgi-bin/print_web_data_v3?site=Barcelona&year=2020&month=6&day=1&year2=2022&month2=6&day2=1&AOD15=1&AVG=10&ldp_year=2022&ldp_month=1&ldp_day=1">
			[01/06/2022] AOD15 Barcelona
		</a>
	</li>

</ul>
</p>

</body>
</html>
