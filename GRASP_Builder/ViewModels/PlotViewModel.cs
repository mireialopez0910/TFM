using Avalonia.Controls;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace GRASP_Builder.ViewModels
{
    public class PlotViewModel : ViewModelBase
    {
        #region Constructor

        public PlotViewModel()
        {
            Messenger.Default.Register<object>("ReloadMeasureID", ReloadMeasureID);
        }
        #endregion

        #region Members

        string matlabOutputDirectory = AppConfig.Instance.GetValue("MatlabOutputDirectory");
        string figureFolder;

        #endregion

        #region Bindings

        private ObservableCollection<string> _measureIDOptions = new ObservableCollection<string>();
        public ObservableCollection<string> MeasureIDOptions
        {
            get => _measureIDOptions;
            set => SetProperty<ObservableCollection<string>>(ref _measureIDOptions, value);
        }

        private string _selectedMeasureID = string.Empty;
        public string SelectedMeasureID
        {
            get => _selectedMeasureID;
            set
            {
                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"Selected measure ID value modified to: {value}");
                SetProperty<string>(ref _selectedMeasureID, value);
                FindSpecificFolders();
            }
        }

        private ObservableCollection<string> _figureToShowOptions = new ObservableCollection<string>();
        public ObservableCollection<string> FigureToShowOptions
        {
            get => _figureToShowOptions;
            set => SetProperty<ObservableCollection<string>>(ref _figureToShowOptions, value);
        }

        private string _selectedFigureToShow = string.Empty;
        public string SelectedFigureToShow
        {
            get => _selectedFigureToShow;
            set
            {
                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"Selected measure ID value modified to: {value}");
                SetProperty<string>(ref _selectedFigureToShow, value);
            }
        }

        private ObservableCollection<string> _fileToShowOptions = new ObservableCollection<string>();
        public ObservableCollection<string> FileToShowOptions
        {
            get => _fileToShowOptions;
            set => SetProperty<ObservableCollection<string>>(ref _fileToShowOptions, value);
        }

        private string _selectedFileToShow = string.Empty;
        public string SelectedFileToShow
        {
            get => _selectedFileToShow;
            set
            {
                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"Selected measure ID value modified to: {value}");
                SetProperty<string>(ref _selectedFileToShow, value);
                ReloadFigureFiles();
            }
        }

        #endregion

        #region Commands

        public ICommand ReloadMeasureIDCmd => new RelayCommand(ReloadMeasureIDExecute, CanReloadMeasureID);
        private void ReloadMeasureIDExecute(object _)
        {
            ReloadMeasureID();

            SelectedMeasureID=string.Empty;
            SelectedFileToShow = string.Empty;
            SelectedFigureToShow = string.Empty;
        }

        private bool CanReloadMeasureID(object _)
        {
            return true;
        }

        public ICommand SaveFiguresCmd => new RelayCommand(SaveFiguresExecute, CanSaveFigures);
        private void SaveFiguresExecute(object _)
        {

        }

        private bool CanSaveFigures(object _)
        {
            return true;
        }

        public ICommand PlotFigureCmd => new RelayCommand(PlotFigureExecute, CanPlotFigure);
        private void PlotFigureExecute(object _)
        {

        }

        private bool CanPlotFigure(object _)
        {
            return true;
        }

        #endregion

        #region Methods

        private void ReloadMeasureID(object _ = null)
        {
            Logger.Log("Loading Measures ID");

            if (Directory.Exists(matlabOutputDirectory))
            {
                // Obtain all subfolders in matlabOutputDirectory
                var measureIDSubFolders = Directory.GetDirectories(matlabOutputDirectory);

                Logger.Log("Subcarpetas en la carpeta measureID:");
                Logger.Log("Measure ID found: " + measureIDSubFolders.Length);

                //update MeasureIDOptions combobox
                MeasureIDOptions.Clear();
                foreach (var folder in measureIDSubFolders)
                {
                    string folderName = Path.GetFileName(folder);
                    MeasureIDOptions.Add(folderName);
                    Logger.Log("Measure ID: " + folderName);
                }
            }
            else
            {
                Logger.Log($"Folder {matlabOutputDirectory} does not exist");
            }
        }

        private void FindSpecificFolders()
        {
            string currentFolder = Directory.GetCurrentDirectory();

            string measureIDFolder = Path.Combine(currentFolder, matlabOutputDirectory, SelectedMeasureID);

            Logger.Log($"Analizing {measureIDFolder} folder . . .");

            // Obtener subcarpetas
            string[] subFolders = Directory.GetDirectories(measureIDFolder);

            // Lista de prefijos válidos
            string[] prefixList = { "D1_L", "D1_L_VD", "D1P_L", "D1P_L_VD" };

            foreach (var folder in subFolders)
            {
                string folderName = Path.GetFileName(folder);

                // Folder name should start with the corresponding configuration name
                foreach (var prefix in prefixList)
                {
                    if (folderName.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
                    {
                        FileToShowOptions.Add(folderName);
                        Logger.Log($"Folder {folderName} found");
                        break;
                    }
                }
            }
        }

        private void ReloadFigureFiles()
        {
            string currentFolder = Directory.GetCurrentDirectory();

            figureFolder = Path.Combine(currentFolder, matlabOutputDirectory, SelectedMeasureID, SelectedFileToShow, "figures");

            var figureFileList = Directory.GetFiles(figureFolder, "*.mat");

            //add available figures in combobox list options
            FigureToShowOptions.Clear();
            foreach (var file in figureFileList)
            {
                string nameWithoutExt = Path.GetFileNameWithoutExtension(file);
                FigureToShowOptions.Add(nameWithoutExt);
            }

            string message = $"Figures found in {figureFolder}...";

            foreach (var file in figureFileList)
            {
                message += file + "; ";
            }
            Logger.Log(message);
        }

        #endregion

        
    }
}