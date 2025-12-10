
%%! DataCrossing < matlab.apps.AppBase
%!
%%! Descripció
%!
%! *Interfície gràfic DataCrossing (mlapp)*
%!
%! Aquest document ofereix informació tècnica sobre les principals funcions
%! incloses al GUIApp de l'aplicació
%!

%%! Propietats del GUI
%! Propietats públiques creades a partir dels components de la interfície
%!
%! *Property name (Classe)*
%!
%! * UIFigure                        (matlab.ui.Figure)
%! * TabGroup                        (matlab.ui.container.TabGroup)
%! * AuthenticationTab               (matlab.ui.container.Tab)
%! * StatusLamp                      (matlab.ui.control.Lamp)
%! * StatusLampLabel                 (matlab.ui.control.Label)
%! * PasswordEditField               (matlab.ui.control.EditField)
%! * PasswordEditFieldLabel          (matlab.ui.control.Label)
%! * UsernameEditField               (matlab.ui.control.EditField)
%! * UsernameEditFieldLabel          (matlab.ui.control.Label)
%! * SCCpasswordEditField            (matlab.ui.control.EditField)
%! * SCCpasswordEditFieldLabel       (matlab.ui.control.Label)
%! * SCCuserEditField                (matlab.ui.control.EditField)
%! * SCCuserEditFieldLabel           (matlab.ui.control.Label)
%! * Label_2                         (matlab.ui.control.Label)
%! * Image                           (matlab.ui.control.Image)
%! * PersonalSCCAuthenticationLabel  (matlab.ui.control.Label)
%! * LoginButton                     (matlab.ui.control.Button)
%! * GenericSCCAuthenticationLabel   (matlab.ui.control.Label)
%! * PreBuildingTab                  (matlab.ui.container.Tab)
%! * CurrentIDEditField              (matlab.ui.control.EditField)
%! * CurrentIDEditFieldLabel         (matlab.ui.control.Label)
%! * HeightmaxSpinner                (matlab.ui.control.Spinner)
%! * HeightmaxSpinnerLabel           (matlab.ui.control.Label)
%! * HeightminSpinner                (matlab.ui.control.Spinner)
%! * HeightminSpinnerLabel           (matlab.ui.control.Label)
%! * StopdateDatePicker              (matlab.ui.control.DatePicker)
%! * StopdateDatePickerLabel         (matlab.ui.control.Label)
%! * StartDateDatePicker             (matlab.ui.control.DatePicker)
%! * StartDateDatePickerLabel        (matlab.ui.control.Label)
%! * AltiudeSwitch                   (matlab.ui.control.Switch)
%! * ExportLIDARCheckBox             (matlab.ui.control.CheckBox)
%! * RButton_2                       (matlab.ui.control.Button)
%! * RButton                         (matlab.ui.control.Button)
%! * ViewfiguresCheckBox             (matlab.ui.control.CheckBox)
%! * StopdateDatePickerLabel_5       (matlab.ui.control.Label)
%! * PlotdataButton                  (matlab.ui.control.Button)
%! * GRASPfilebuilderLabel           (matlab.ui.control.Label)
%! * SendButton                      (matlab.ui.control.Button)
%! * SettingsButtonGroup             (matlab.ui.container.ButtonGroup)
%! * D1P_L_VDPhotom_pollidar_depButton  (matlab.ui.control.RadioButton)
%! * D1_L_VDPhotometerlidar_depButton  (matlab.ui.control.RadioButton)
%! * D1P_LPhotom_pollidarButton      (matlab.ui.control.RadioButton)
%! * D1_LPhotometerlidarButton       (matlab.ui.control.RadioButton)
%! * StopdateDatePickerLabel_2       (matlab.ui.control.Label)
%! * DatacollectionLabel             (matlab.ui.control.Label)
%! * FilterbydatesLabel              (matlab.ui.control.Label)
%! * AcceptButton                    (matlab.ui.control.Button)
%! * SelectedIDLabelDropDown         (matlab.ui.control.DropDown)
%! * FilterdatesButton               (matlab.ui.control.Button)
%! * DatabaseloadLabel               (matlab.ui.control.Label)
%! * LoadButton                      (matlab.ui.control.Button)
%! * PlotTab                         (matlab.ui.container.Tab)
%! * Button                          (matlab.ui.control.Button)
%! * PlotfigureButton                (matlab.ui.control.Button)
%! * SelectthefiguretoshowDropDown   (matlab.ui.control.DropDown)
%! * SelectthefiguretoshowLabel      (matlab.ui.control.Label)
%! * Label_3                         (matlab.ui.control.Label)
%! * Label_4                         (matlab.ui.control.Label)
%! * SelectaconfigurationDropDown    (matlab.ui.control.DropDown)
%! * SelectaconfigurationDropDownLabel  (matlab.ui.control.Label)
%! * SelectaMeasureIDDropDown        (matlab.ui.control.DropDown)
%! * SelectaMeasureIDDropDownLabel   (matlab.ui.control.Label)
%! * Button_2                        (matlab.ui.control.Button)
%! * SavefiguresButton               (matlab.ui.control.Button)
%! * HelpTab                         (matlab.ui.container.Tab)
%! * Tree                            (matlab.ui.container.Tree)
%! * UserGuidesNode                  (matlab.ui.container.TreeNode)
%! * FunctionsNode                   (matlab.ui.container.TreeNode)
%! * HTML                            (matlab.ui.control.HTML)
%! * LIDARButton                     (matlab.ui.control.Button)
%! * StopdateDatePickerLabel_7       (matlab.ui.control.Label)
%! * StopdateDatePickerLabel_6       (matlab.ui.control.Label)
%! * OutputButton                    (matlab.ui.control.Button)
%! * AeronetButton                   (matlab.ui.control.Button)
%! * Hyperlink                       (matlab.ui.control.Hyperlink)
%! * DataCrossingLabel               (matlab.ui.control.Label)
%! * StopdateDatePickerLabel_4       (matlab.ui.control.Label)
%! * DataBaseTextArea                (matlab.ui.control.TextArea)
%! * UIAxes                          (matlab.ui.control.UIAxes)

%! *Propietats públiques personalitzades*
%!
%! Properties personalitzades usades durant el cicle de l'aplicació.
%!
%! *Propietat (ús)*
%!
%! * RealSCCPassword (Emmagatzema la contrasenya real genèrica)
%! * RealPassword (Emmagatzema la contrasenya real personalitzada)

%! * Auth (estructura per moure les credencials)
%! * measureIDFolder (Guarda la carpeta dels measuresID)
%! * selected_measure_ID (conté la mesura seleccionada)

%! * logger = [] (conté la informació a incloure al log de l'app);
%! * system_ids = [];

%! * foundFilesELDA (control de fitxers ELDA trobats)
%! * foundFilesAOD (control de fitxers AOD trobats)
%! * foundFilesALM (control de fitxers ALM trobats)
%! * foundFilesALP (control de fitxers ALP trobats)
%! * foundFilesALL (control de fitxers ALL trobats)

%! * heightELPPLimitMin (estableix el límit mínim d'alçada ELPP)
%! * heightELPPLimitMax (estableix el límit mínim d'alçada ELPP)
%! * heightVDLimitMin (estableix el límit mínim d'alçada de despolarització de volum)
%! * heightVDLimitMax (estableix el límit mínim d'alçada de despolarització de volum)


%%! Private Functions
%! S'enumeren les funcions (privades) que afecten la interfície
%! (no s'hi inclouen funcions addicionals fora de l'app principal.


%%! [foundFilesAOD, foundFilesAlm, foundFilesAlp, foundFilesAll] = loadResources(app)
%! Carregueu els recursos estàtics de l'aplicació que són els fitxers
%! corresponents a les taules de mesures d'Aeronet/Almucantar.
%! Aquests fitxers es troba a la carpeta del repositori i
%! es poden actualitzar mantenint les especificacions de
%! compatibilitat definides en la descripció de cadascun dels
%! fitxers (definició de noms de camps de les taules)
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * |foundFilesAOD: [int]| -
%! Fitxers AOD trobats al repositori
%!
%! * |foundFilesAlm: [int]| -
%! Fitxers ALM trobats al repositori
%!
%! * |foundFilesAlp: [int]| -
%! Fitxers ALP trobats al repositori
%!
%! * |foundFilesAll: [int]| -
%! Fitxers ALL trobats al repositori
%!



%%! logMessage(app, message)
%! Imprimeix un missatge de text al contenidor de logs
%! La funció afegeix automàticament la data d'impressió de log
%! (quan es va generar l'esdeveniment) i l'hora
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |message: [string]| -
%! Missatge de text per imprimir al log
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! measuresIDfound = reloadMeasuresID(app)
%!
%! Actualitza les mesures disponibles MeasureID
%! adequada per poder ser utilitzats en les funcions de càlcul i plotejat:
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! plotter(app)
%!
%! Dibuixa al visor les gràfiques representatives de la mesura
%! i alçades seleccionades que es troba a l'espai de
%! treball (identificable com a tipus elda a l'espai de noms)
%!
%! *Volume Depolarization*
%!
%! Analitza si hi ha dades VD de despolarització i si les
%! troba els ploteja també. Si hi ha valors no vàlids a
%! altura (Nan) als seus extrems (mínim i màxim) llança una alerta
%! per prevenir errors en el processament GRASP posterior. Aplica
%! un factor d'amplificació de 10^11
%!
%! *Total Power Channel*
%!
%! Extrau la informació d'ELPP per obtenir Total Power Channel (TPC)
%! Cerca vectors de dades amb valors per a Total Power Channel
%! Si trobeu valors vàlids per a la longitud d'ona 1064 li
%! aplica, un factor d'amplificació. Per defecte està definit
%! a 10000.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! [minELPPAltitude, maxELPPAltitude, minVDAltitude, maxVDAltitude] = getValidEldaAltitude(app)
%!
%! Detecta les dades ELDA vàlides (no NaN) per a l'alçada mínima i màxima.
%! Addicionalment cercarà informació de Despolarització del Volum.
%! Si la troba, també tornarà els valors mímims i vàlids d'alçada.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * |minELPPAltitude: [int]| -
%! Valor vàlid de l'alçada mínima
%!
%! * |maxELPPAltitude: [int]| -
%! Valor vàlid de l'alçada mínima
%!
%! * |minVDAltitude: [int]| -
%! Valor vàlid de l'alçada mínima per al Volum de Despolarització
%!
%! * |maxVDAltitude: [int]| -
%! Valor vàlid de l'alçada màxima per al Volum de Despolarització
%!




%%! urltofigurefiles = reloadFigureFiles(app)
%!
%! Torna la ruta on s'ubica les gràfiques per a una mesura i configuració determinada.
%! Tant la mesura amb la configuració es detecten dels
%! corresponents components de selecció del GUI:
%!
%! * SelectaMeasureIDDropDown
%! * SelectaconfigurationDropDown
%!
%! Ruta: /<currentFolder>/<output>/<measure>/<configuration>/figures/'|
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * |urltofigurefiles: [string]| -
%! ruta a la carpeta de gràfiques per a una mesura i configuració
%!



%%! startupFcn(app)
%!
%! Aquesta funció s'executa després de la creació dels components i inicialitza
%! els tres mòduls de la interfície:
%!
%! *Mòdul de credencials (Authentication)*
%!
%! Carrega fitxer de configuració per obtenir les credencials.
%! *Atenció:* Les credencials només s'han d'emmagatzemar en mode test
%! per facilitar-ne l'accés de forma ràpida. Un cop en producció
%! s'han d'esborrar per ser introduïdes manualment per l'usuari.
%!
%! Degut a les limitacions de MatLabs no hi ha camps de tipus clau
%! i se simulen mitjançant una funció a mida.
%!
%! *Mòdul de representació (Plotting)*
%!
%! Crea la ruta cap a la carpeta contenidora de mesures (measureID)
%! Carrega les mesures disponibles a la carpeta al selector de mesures.
%! Carrega les configuracions disponibles a la carpeta al selector de configuracions.
%! Carrega les gràfiques disponibles a la carpeta per a una
%! configuració definida al selector de gràfiques (figures).
%!
%! *Mòdul de modelatge de dades (Prebuild)*
%!
%! Es desactiven els elements interactuables de la interfície
%! Crea l'estructura de directoris per als recursos AERONET si no existeix
%! Els fitxers esperats d'AERONET s'han de col·locar en aquesta
%! carpeta manualment.
%! Carrega els fitxers Aeronet i Almucantar (AOD, ALM, ALP, ALL)
%! Es registren a les propietats corresponents els fitxers trobats.
%!
%! *Mòdul d'ajuda (Help)*
%!
%! Defineix la ruta del directori on es troben els fitxers
%! publicats per a la secció de funcions i la de guies.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! LoadButtonPushed(app)
%!
%! Obre un quadre de diàleg per seleccionar el fitxer CSV
%! d'entrada que contindrà la base de dades de mesures disponibles.
%! (MeasureID). Si es carrega correctament s'assignarà a una taula
%! al workspace anomenada 'tDatabase'
%!
%! A continuació cerca el fitxer de configuració a la ruta
%! predefinida al fitxer de configuració i llegeix la primera
%! columna on s'assumeix per convenció que hi ha els identificadors vàlids a creuar
%! amb la base de dades prèviament carregada.
%! El resultat és la llista de MeasureID vàlids sobre els quals es
%! podrà treballar.
%!
%! Si trobeu IDs vàlids s'activaran els components de
%! selecció de data per filtrar
%!
%! En cas que no es puguin llegir els fitxers mostrarà el missatge
%! derror corresponent.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! FilterdatesButtonPushed(app, event)
%!
%! En prémer el botó de filtrar per dates 'Filter dates' es desencadenen
%! diferents processos que permeten filtres les dades de les mesures disponibles
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [App object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!
%!
%! En detall:
%!
%! * Comprova que la taula 'tDatabase' existeix al workspace
%! i activa el selector de mesures (measureID) i el botó 'Accept'.
%! Si no existeix, mostra un missatge d'error.
%!
%! * Filtra les entrades a 'tDatabase' el 'system_id' del qual coincideixin
%! amb la llista precarregada de la configuració i crea la taula
%! 'tfMeasures'.
%!
%! * Aplica un filtratge basat en rang de dates sobre les dades
%! anteriors usant 'StartDateDatePicker' i 'StopdateDatePicker'
%! del component de la interfície assignant-los a la taula 'T_filt'
%! carregant-la al selector 'SelectedIDLabelDropDown'





%%! SelectedIDLabelDropDownValueChanged(app, event)
%!
%! Assigna la variable |app.selected_measure_ID| l'identificador
%! de la mesura seleccionada al selector de mesures disponibles
%! quan aquest canvia dopció.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!






%%! AcceptButtonPushed(app, event)
%!
%! En accionar el botó |AcceptButton| descarrega els fitxers LIDAR
%! referits a la mesura (measureID) seleccionada per al rang de
%! dates entre 'Start Date' i 'Stop Date'
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!
%! *En detall*
%!
%! * Identifica la mesura
%! * Descarrega els fitxers ELDA i ELPP usant la funció
%! * download(...) passant com a paràmetre l'ID de la mesura i el
%! * tipus de fitxer a descarregar (ELDA o ELPP). És invocat dues vegades (un per a cada tipus).
%! * Si tornen algun error es mostra a la consola de log i finalitza el procés de descàrrega.
%! * Neteja possibles taules prèvies ELDA al workspace.
%! * Desactiva els spinners d'alçades mínima i màxima.
%! * Desactiva els botons de reinici d'altures mínima i màxima.
%! * Desactiva totes les configuracions del selector.
%! * Si trobeu fitxers ELDA procedeix a analitzar-lo amb la funció
%! |checkElda(...)| i torna l'estat i un missatge per a cadascuna de les
%! longituds d'ona inspecionades: (status_1064, message_1064,
%! status_0532, message_0532, status_0355, message_0355]
%!
%! * Es verifica els arxius obtinguts permetent un màxim de dos fitxers AOD (contemplant
%! fitxer lunar), un per ALM i un per ALL. En cas de
%! trobar algun problema amb algun d'ells, mostra en una finestra de
%! diàleg cada tipus derror.
%!
%! Si els fitxers requerits són correctes:
%!
%! * Busca els límits d'altitud als ELDAs i se'ls assigna als components del GUI
%! * S'activa el component 'switch' per a 'ELPP/VD' si troba altura al canal Volume Depolarization (VD)
%! * Configura els spinners
%! ** Defineix el format dels spinners d'alçada com a enters (sense decimals)
%! ** Si el 'switch' està en mode ELPP assigna els limits dels
%! spinners als mínims i màxims trobats als vectors de
%! dades ignorant el canal VD (en cas que existeixi)
%! ** Si el 'switch' està en mode VD assigna els limits dels
%! spinners als mínims i màxims trobats als vectors de
%! dades VD
%!
%! * activa els spinners
%! * activa els botons de reinici dels spinners
%! * activa el botó de ploteig 'PlotDataButton'
%! ** Si el 'switch' està en mode ELPP, assigna el valor mínim ELPP al
%! spinner d'alçada mínima i el valor màxim ELPP en spinner d'alçada màxima.
%! ** Si el 'switch' està en mode VD, assigna el valor mínim VD al
%! spinner d'alçada mínima i el valor màxim VD en spinner d'alçada màxima
%!
%! * recupera les dades filtrades entre les dates
%! seleccionades a les taules AOD, ALM, ALP, ALL i ELDA
%! utilitzant la funció |getFilteredTable(...)|
%! que torna una taula amb les dades filtrades i un
%! comptador de línies trobades per a cadascuna
%! * Crea les taules anteriors al workspace
%! * Verifica si hi ha dades a les taules filtrades ALM & AOD.
%! Si no fos així, mostra l'error en un quadre de diàleg
%! * Comprova quines configuracions estan disponibles amb la funció
%! |checkSendDataConfigs(...)| i les activa al component GUI
%! d'opcions de configuracions.





%%! SettingsButtonGroupSelectionChanged(app, event)
%!
%! Assigna a la variable |selectedButton| el valor de l'opció
%! escollida al selector de configuracions de mesures quan
%! el selector canvia.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! SendButtonPushed(app, event)
%!
%! Invoca la funció encarregada d'escriure el fitxer de
%! configuració de mesura segons la selecció realitzada al
%! selector |SettingsButtonGroup| corresponent.
%!
%! * |sendData_D1P_L_VD(...)|
%! * |sendData_D1P_L(...)|
%! * |sendData_D1_L_VD(...)|
%! * |sendData_D1_L(...)|
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! HeightminSpinnerValueChanged(app, event)
%!
%! Verifica que quan canvia el valor de l'spinner d'alçada mínima
%! no sobrepassa els límits inferior i superior corresponents al
%! tipus canal que té seleccionat (ELDA o VD).
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! HeightmaxSpinnerValueChanged(app, event)
%!
%! Verifica que quan canvia el valor de l'spinner d'alçada màxima
%! no sobrepassa els límits inferior i superior corresponents al
%! tipus canal que té seleccionat (ELDA o VD).
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! PlotdataButtonPushed(app, event)
%!
%! En prémer sobre el component 'PlotdataButton' invoca la funció
%! 'plotter(...) per graficar al visor les dades de la mesura
%! LIDAR seleccionada.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! RButton_2Pushed(app, event)
%!
%! En prémer sobre el component 'RButton_2' reinicia els valors del
%! spinner d'alçada màxima als límits màxims per defecte.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! RButtonPushed(app, event)
%!
%! En prémer sobre el component 'RButton' reinicia els valors del
%! spinner d'alçada mínima als límits mínims per defecte.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!  






%%! HyperlinkClicked(app, event)
%!
%! En prémer sobre el component 'Hyperlink' esborra el contingut del
%! log en pantalla.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! AeronetButtonPushed(app, event)
%!
%! En prémer sobre el component 'AeronetButton' Obre una finestra
%! al sistema per mostrar la carpeta que conté els fitxers
%! AERONET. Si la carpeta no existeix, mostra un error a la pantalla.
%!
%! Ruta: &gt;root_folder&rt;/&gt;CONFIG_LIDAR_folder&rt;
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! OutputButtonPushed(app, event)
%!
%! En prémer sobre el component 'OutputButton' Obre una finestra
%! al sistema per mostrar la carpeta de sortida on es generen
%! els fitxers '*.sat', '*.mat' i 'figures' amb els seus corresponents
%! gràfiques. Si la carpeta no existeix, mostra un error a la pantalla.
%!
%! Ruta: &gt;root_folder&rt;/&gt;CONFIG_output&rt;
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! LIDARButtonPushed(app, event)
%!
%! En prémer sobre el component 'LIDARButton' Obre una finestra
%! al sistema per mostrar la carpeta que conté els fitxers LIDAR
%! descarregats per cada mesura seleccionada. Si la carpeta no
%! hi ha mostra un error en pantalla.
%!
%! Ruta: &gt;root_folder&rt;/&gt;CONFIG_LIDAR_folder&rt;
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! AltiudeSwitchValueChanged(app, event)
%!
%!
%! Obté els valors mínims i màxims d'alçada de 'Total Power
%! Channel' i 'Volume Depolarization' usant la funció
%! 'getValidEldaAltitude(...)' i els assigna segons els seleccioneu
%! al component 'AltiudeSwitch' l'opció 'ELPP' o 'VD' com a valors
%! i límits als spinners 'HeightminSpinner' i 'HeightmaxSpinner'
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!






%%! LoginButtonPushed(app)
%!
%! Carrega les dues credencials a l'estructura |app.Auth| i s'envien
%! amb la funció AuthSCCAccess(...) al servidor perquè determini si
%! són vàlides o no retornant dos paràmetres:
%!
%! * isValid: [boolean] indicant si les credencials han estat acceptades
%! * message: [string] amb un missatge descriptiu del resultat]
%!
%! *Si les credencials són correctes* el led situat a l'esquerra
%! del botó de 'Login' es posarà de color verd i tant el botó
%! de càrrega de base de dades com a checkbox per visualitzar figures
%! s'habilitaran.
%!
%! *Si les credencials no són correctes* el led es posarà de color
%! vermell i els components esmentats anteriorment es deshabilitaran
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! SelectaMeasureIDDropDownValueChanged(app)
%!
%! Funció que s'invoca quan canvia el valor del selector de mesures
%! (MeasureID). Invoca la funció findSpecificFolders(...) per
%! trobar la ruta on s'ubiquen les configuracions per a la
%! mesura seleccionada i se li assigna al selector de configuracions.
%! Finalment, recarrega les gràfiques disponibles per a la
%! configuració assignada al selector. Si no hi ha cap gràfica
%! disponible desactiva el botó de representar gràfiques (PlotfigureButton)
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! SelectaMeasureIDDropDownOpening(app)
%!
%! Funció que s'invoca quan s'obre el selector de mides
%! (MeasureID). Invoca la funció findSpecificFolders(...) per
%! trobar la ruta on s'ubiquen les configuracions per a la
%! mesura seleccionada i se li assigna al selector de configuracions.
%! Finalment, recarrega les gràfiques disponibles per a la
%! configuració assignada al selector.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!



%%! SavefiguresButtonPushed(app, event)
%!
%! Llança la petició de ploteig per a la mesura i configuració
%! seleccionada als selectors corresponents de la interfície.
%1 Prèviament identifica el tipus de configuració seleccionada i
% executa la funció de ploteig requerida.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!
%!
%! *Nota 1:* Es distingeixen en codi les diferents configuracions
%! per motius d'escalabilitat en futures versions, però a
%! l'actual les quatre configuracions invoquen la mateixa funció de
%! ploteig.
%!
%! *Nota 2:* El botó es desactiva una vegada premut fins que finalitza
%! el plotejat de les dades. D'aquesta manera s'impedeix iniciar un nou
%! ploteig abans de finalitzar l'anterior i el consegüent missatge d'error
%! del sistema.
%!
%! Es defineixen totes les longituds d'ones utilitzades a l'entrada de GRASP.
%!
%! * Lambda: 355,380,440,500,532,675,870,1020,1064,1640
%! * Waves_AERONET2: 380,440,500,675,870,1020,1640
%!
%! Valors de GRASP a VSD:
%!
%! * size_binsF: 0.05,0.0656,0.086,0.11294,0.14818,0.19443,0.25511,
%! 0.33472,0.43917,0.57623];
%! * size_binsC: 0.33472,0.43917,0.57623,0.75605,0.99199,1.3016,1.7078,
% 2.2407,2.94,3.8575,5.0613,6.6407,8.7131,11.432,15];
%!
%! Finalment, invoca la funció grasp_plotting_UPC(...) amb la configuració
%! corresponent per iniciar el procés de generació de gràfiques
%!





%%! Button_2Pushed(app, event)
%!
%! Actualitza les mesures i les gràfiques disponibles a tots dos selectors invocant les funcions:
%!
%! * reloadMeasuresID(app);
%! * reloadFigureFiles(app);
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!





%%! TreeSelectionChanged(app, event)
%!
%! S'executa després de l'esdeveniment de canvi de node de l'arbre d'ajuda.
%! Si el node i el valor no estan buits, envieu l'URL al contenidor
%! HTML per mostrar el fitxer d'ajuda corresponent (app.HTML.HTMLSource).
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!



%%! SCCpasswordEditFieldValueChanging(app, event)
%!
%! Aquesta funció pertany al conjunt de simulació de camps
%! de contrasenya que amaga la clau amb asteriscs.
%! Es llença l'esdeveniment quan es perd el focus sobre el component
%! (per ex. escriure o esborrar-ne el contingut i es canvia a un altre component).
%!
%! En detall:
%! Obté el valor visible actual al camp (cosa que l'usuari
%! escriu), actualitza la contrasenya real directament des del camp
%! visible i reemplaça el contingut visible del camp amb asteriscs.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!






%%! PasswordEditFieldValueChanging(app, event)
%!
%! Aquesta funció pertany al conjunt de simulació de camps
%! de contrasenya que amaga la clau amb asteriscs.
%! Es llança l'esdeveniment quan es produeix qualsevol modificació al
%! camp (per ex. escriure o esborrar un caràcter.
%! En detall:
%!
%! Obté el valor visible actual al camp (cosa que l'usuari
%! escriu), actualitza la contrasenya real directament des del camp
%! visible i reemplaça el contingut visible del camp amb asteriscs.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! * |event: [event object]| -
%! Executeu la funció quan es produeix l'esdeveniment assignat. A
%! aquest cas la pulsació del botó
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!



%%! SelectaconfigurationDropDownValueChanged(app)
%!
%! Aquesta funció és cridada quan el valor del selector de
%! configuració canvia.
%! Recarrega el contingut del selector de gràfics i si no conté
%! cap que estigui disponible per ser representada, deshabilita el
%! botó que mostra les gràfiques (PlotfigureButton).
%! En cas contrari ho activa.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!



%%! reloadFigureFiles(app)
%!
%! Aquesta funció és cridada quan el valor del selector de
%! figures canvia i s'assegura que en contingui alguna abans
%! d'activar el botó que permet mostrar les gràfiques (PlotfigureButton).
%! En cas contrari ho desactiva.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!



%%! PlotfigureButtonPushed(app)
%!
%! Imprimeix el gràfic seleccionat al selector |SelectthefiguretoshowDropDown|
%! Per això primer carrega la gràfica des del fitxer en mode
%! 'invisible' i procedeix a copiar-la al visor de la interfície:
%!
%! * Verifica si hi ha eixos a la figura
%! * Si només hi ha un eix, treballa amb ell directament
%! * Copia els fills (dades del gràfic) al UIAxes
%! * Copia les etiquetes dels eixos (X, Y, Títol)
%! * Copia la llegenda si existeix
%! * Elimina la figura oculta.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! ButtonPushed(app)
%!
%! Esborra la gràfica del visor UIAxes i reinicia els seus valors als
%! de per defecte.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! createComponents(app)
%!
%! Crea els components de la interfície gràfica. A continuació es llisten els components
%! que es creen a la interfície:
%!
%! * Create UIFigure and hide until all components are created
%! * Create UIAxes
%! * Create DataBaseTextArea
%! * Create StopdateDatePickerLabel_4
%! * Create DataCrossingLabel
%! * Create Hyperlink
%! * Create AeronetButton
%! * Create OutputButton
%! * Create StopdateDatePickerLabel_6
%! * Create StopdateDatePickerLabel_7
%! * Create LIDARButton
%! * Create TabGroup
%! * Create AuthenticationTab
%! * Create GenericSCCAuthenticationLabel
%! * Create LoginButton
%! * Create PersonalSCCAuthenticationLabel
%! * Create Image
%! * Create Label_2
%! * Create SCCuserEditFieldLabel
%! * Create SCCuserEditField
%! * Create SCCpasswordEditFieldLabel
%! * Create SCCpasswordEditField
%! * Create UsernameEditFieldLabel
%! * Create UsernameEditField
%! * Create PasswordEditFieldLabel
%! * Create PasswordEditField
%! * Create StatusLamp
%! * Create PreBuildingTab
%! * Create LoadButton
%! * Create DatabaseloadLabel
%! * Create FilterdatesButton
%! * Create SelectedIDLabelDropDown
%! * Create AcceptButton
%! * Create FilterbydatesLabel
%! * Create DatacollectionLabel
%! * Create StopdateDatePickerLabel_2
%! * Create SettingsButtonGroup
%! * Create D1_LPhotometerlidarButton
%! * Create D1P_LPhotom_pollidarButton
%! * Create D1_L_VDPhotometerlidar_depButton
%! * Create D1P_L_VDPhotom_pollidar_depButton
%! * Create SendButton
%! * Create GRASPfilebuilderLabel
%! * Create PlotdataButton
%! * Create StopdateDatePickerLabel_5
%! * Create ViewfiguresCheckBox
%! * Create RButton
%! * Create RButton_2
%! * Create ExportLIDARCheckBox
%! * Create AltiudeSwitch
%! * Create StartDateDatePickerLabel
%! * Create StartDateDatePicker
%! * Create StopdateDatePickerLabel
%! * Create StopdateDatePicker
%! * Create HeightminSpinnerLabel
%! * Create HeightminSpinner
%! * Create HeightmaxSpinnerLabel
%! * Create HeightmaxSpinner
%! * Create CurrentIDEditFieldLabel
%! * Create CurrentIDEditField
%! * Create PlotTab
%! * Create SavefiguresButton
%! * Create Button_2
%! * Create SelectaMeasureIDDropDownLabel
%! * Create SelectaMeasureIDDropDown
%! * Create SelectaconfigurationDropDownLabel
%! * Create SelectaconfigurationDropDown
%! * Create Label_4
%! * Create Label_3
%! * Create SelectthefiguretoshowLabel
%! * Create SelectthefiguretoshowDropDown
%! * Create PlotfigureButton
%! * Create Button
%! * Create HelpTab
%! * Create HTML
%! * Create Tree
%! * Create UserGuidesNode
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que creeu
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!




%%! app = DataCrossing
%!
%! És el constructor de l'aplicació:
%!
%! * Crea la interfície i els seus components
%! * Registra l'app a l'App Designer
%! * Executa la funció d'arrencada runStartupFcn(...)
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * No teniu paràmetres d'entrada
%!
%! *VALORS DE SORTIDA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que heu creat
%!




%%! delete(app)
%!
%! Aquesta funció s'executa abans d'eliminar l'aplicació i eliminar tots els
%! components de la interfície quan l'app s'elimina.
%!
%! *PARÀMETRES D'ENTRADA*
%!
%! * |app: [app object]| -
%! Instància de la classe de l'aplicació que heu creat
%!
%! *VALORS DE SORTIDA*
%!
%! * No torna cap valor
%!


