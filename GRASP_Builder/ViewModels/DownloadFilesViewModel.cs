using Avalonia.Controls.Shapes;
using Avalonia.Logging;
using Avalonia.Styling;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Messaging;
using GRASP_Builder.UIElement;
using Microsoft.VisualBasic.FileIO;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net.Http;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Security.AccessControl;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;
using System.IO;
using Tmds.DBus.Protocol;
using static System.Runtime.InteropServices.JavaScript.JSType;
using GRASP_Builder.AppCode.DownloadControllers;
using Microsoft.VisualBasic;

namespace GRASP_Builder.ViewModels
{
    public enum FileType
    {
        ELPP,
        Optical,
        AeronetInversions,
        AeronetAOD,
        AeronetSDA,
        AeronetRawAlmucantar,
        AeronetRawPolarizedAlmucantar
    }

    public class DownloadFilesViewModel : ViewModelBase
    {
        #region Constructor

        public DownloadFilesViewModel()
        {
            DownloadedFiles_EARLINET = new ObservableCollection<CheckItem>();
            DownloadedFiles_AERONET = new ObservableCollection<CheckItem>();

            Messenger.Default.Register<bool>("UpdateProjectLoaded", UpdateProjectLoaded);
            Messenger.Default.Register<bool>("UpdateProjectLoaded", UpdateProjectLoaded);
            Messenger.Default.Register<string>("UpdateProgress", UpdateProgress);
        }

        #endregion

        #region Members
        public ObservableCollection<CheckItem> DownloadedFiles_EARLINET { get; set; }
        public ObservableCollection<CheckItem> DownloadedFiles_AERONET { get; set; }

        private EarlinetService _earlinetClient;
        private AeronetService _aeronetService;

        private string _workingDirectory = string.Empty;
        private string _repositoryDirectory = string.Empty;
        string _aeronetRepositoryDirectory = string.Empty;
        string _earlinetRepositoryDirectory = string.Empty;

        #endregion

        #region Bindings

        private DateTime _fromDate = DateTime.Today.AddDays(-7);
        public DateTime FromDate
        {
            get => _fromDate;
            set
            {
                SetProperty<DateTime>(ref _fromDate, value);
                Progress = "0";
            }
        }

        private DateTime _toDate = DateTime.Today;
        public DateTime ToDate
        {
            get => _toDate;
            set
            {
                SetProperty<DateTime>(ref _toDate, value);
                Progress = "0";
            }

        }

        private bool _isDownloadedFilesVisible = false;
        public bool IsDownloadedFilesVisible
        {
            get => _isDownloadedFilesVisible;
            set => SetProperty<bool>(ref _isDownloadedFilesVisible, value);
        }

        private string _progress = "0";
        public string Progress
        {
            get => _progress;
            set => SetProperty<string>(ref _progress, value);
        }

        private bool _isSelectDateEnabled = true;
        public bool IsSelectDateEnabled
        {
            get => _isSelectDateEnabled;
            set => SetProperty<bool>(ref _isSelectDateEnabled, value);
        }

        #endregion

        #region Messaging

        private void UpdateProgress(string value)
        {
            Progress = value;
        }

        private void UpdateProjectLoaded(bool obj)
        {
            if (obj) //if project is unloaded, it is not necessary to initialize variables, it will be done when another project is laoded again
            {
                InitializeRepositories();

                UpdateListOfFiles();

                if (DownloadedFiles_AERONET.Count > 0 || DownloadedFiles_EARLINET.Count > 0)
                {
                    if (AppConfig.Instance.IsDebugging())
                        Logger.Log($"Downloaded files detected: list of files is visible");

                    IsSelectDateEnabled = true;
                    IsDownloadedFilesVisible = true;
                }
            }
        }

        private void InitializeRepositories()
        {

            var projectCfg = (App.Current as App)?.CurrentProjectConfig;

            _workingDirectory = AppConfig.Instance.GetValue("WorkingDirectory");
            _repositoryDirectory = System.IO.Path.Combine(AppConfig.Instance.GetValue("ProjectDirectoryPath"),"Data");

            if (System.IO.Directory.Exists(_workingDirectory))
                System.IO.Directory.Delete(_workingDirectory, true);
            System.IO.Directory.CreateDirectory(_workingDirectory);

            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"RepositoryDirectory: {_repositoryDirectory}");

            _aeronetRepositoryDirectory = projectCfg?.GetValue("AeronetRepositoryDirectory");
            _earlinetRepositoryDirectory = projectCfg?.GetValue("EarlinetRepositoryDirectory");

            if (string.IsNullOrEmpty(_aeronetRepositoryDirectory))
            {
                _aeronetRepositoryDirectory = System.IO.Path.Combine(_repositoryDirectory,"AERONET");
                if (!_aeronetRepositoryDirectory.EndsWith(@"/"))
                    _aeronetRepositoryDirectory = _aeronetRepositoryDirectory + @"/";
                projectCfg.SetValue("AeronetRepositoryDirectory", _aeronetRepositoryDirectory);
            }
            if (string.IsNullOrEmpty(_earlinetRepositoryDirectory))
            {
                _earlinetRepositoryDirectory = System.IO.Path.Combine(_repositoryDirectory,"LIDAR");
                if (!_earlinetRepositoryDirectory.EndsWith(@"/"))
                    _earlinetRepositoryDirectory = _earlinetRepositoryDirectory + @"/";
                projectCfg.SetValue("EarlinetRepositoryDirectory", _earlinetRepositoryDirectory);
            }

            projectCfg.Save();

            if (!System.IO.Directory.Exists(_aeronetRepositoryDirectory))
                System.IO.Directory.CreateDirectory(_aeronetRepositoryDirectory);

            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"AeronetRepositoryDirectory: {_aeronetRepositoryDirectory}");


            if (!System.IO.Directory.Exists(_earlinetRepositoryDirectory))
                System.IO.Directory.CreateDirectory(_earlinetRepositoryDirectory);

            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"EarlinetRepositoryDirectory: {_earlinetRepositoryDirectory}");

            string _matlabOutputDirectory = projectCfg?.GetValue("MatlabOutputDirectory");

            if(string.IsNullOrEmpty(_matlabOutputDirectory))
                projectCfg?.SetValue("MatlabOutputDirectory", $"{AppConfig.Instance.GetValue("ProjectDirectoryPath")}/Output/");
        }

        #endregion

        #region Methods


        private void UpdateFiles(List<string> fileNames, FileType fileType)
        {
            ObservableCollection<string> _measureIDList = new ObservableCollection<string>();
            bool anyFile = false;
            foreach (string file in fileNames)
            {
                anyFile = true;
                switch (fileType)
                {
                    case FileType.ELPP:

                        if (!file.EndsWith(@"/elpp/") && !file.EndsWith(@"/elpp") && !file.EndsWith("_elda.nc"))
                        {
                            DownloadedFiles_EARLINET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                            if (AddToMeasureIDList(file))
                                _measureIDList.Add(System.IO.Path.GetFileName(file));
                        }
                        break;
                    case FileType.Optical:
                        if ((!file.EndsWith(@"/optical_products/") && !file.EndsWith(@"/optical_products")) &&
                            (!file.EndsWith(@"/opticalproducts/") && !file.EndsWith(@"/opticalproducts")) && file.EndsWith("_elda.nc"))
                            DownloadedFiles_EARLINET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                        break;
                    case FileType.AeronetInversions:
                        if (file.EndsWith(".all"))
                        {
                            DownloadedFiles_AERONET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                        }
                        break;
                    case FileType.AeronetAOD:
                        if (file.EndsWith(".lev15"))
                        {
                            DownloadedFiles_AERONET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                        }
                        break;
                    case FileType.AeronetSDA:
                        if (file.EndsWith(".ONEILL_lev15"))
                        {
                            DownloadedFiles_AERONET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                        }
                        break;
                    case FileType.AeronetRawAlmucantar:
                        if (file.EndsWith(".alm"))
                        {
                            DownloadedFiles_AERONET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                        }
                        break;

                    case FileType.AeronetRawPolarizedAlmucantar:
                        if (file.EndsWith(".alp"))
                        {
                            DownloadedFiles_AERONET.Add(new CheckItem { Name = System.IO.Path.GetFileName(file), IsChecked = true });
                        }
                        break;
                }
            }

            //Share list of folders containing the list of available measureID to DataConvinationViewModel
            if (fileType == FileType.ELPP)
                Messenger.Default.Send<ObservableCollection<string>>("UpdateMeasureIDList", _measureIDList);

            if (anyFile) IsDownloadedFilesVisible = true;
        }

        private bool AddToMeasureIDList(string folder)
        {
            List<string> files = FileHelpers.GetAllFiles(folder);
            foreach (string file in files)
            {
                if (!file.EndsWith("_elda.nc") && file.Contains("_007_"))
                    return false;
            }

            return true;
        }
        private void UpdateListOfFiles()
        {
            DownloadedFiles_EARLINET.Clear();
            DownloadedFiles_AERONET.Clear();

            IsDownloadedFilesVisible = false;

            foreach (FileType type in Enum.GetValues(typeof(FileType)))
            {
                if (type != FileType.ELPP && type != FileType.Optical)
                {
                    List<string> list = FileHelpers.GetAllFiles(_aeronetRepositoryDirectory);
                    UpdateFiles(list, type);
                }
                else
                {
                    List<string> list = FileHelpers.GetAllFolders(_earlinetRepositoryDirectory);
                    UpdateFiles(list, type);
                }
            }
        }

        #endregion

        #region Commands

        #region Download files

        public ICommand DownloadCmd => new RelayCommand(async _ => await DownloadExecute(), CanDownload);

        private async Task DownloadExecute()
        {
            IsSelectDateEnabled = false;

            Logger.Log($"Downloading files for selected dates . . .");

            Progress = "0";

            if (FromDate > ToDate)
            {
                Logger.Log("ERROR: FromDate must be earlier than or equal to ToDate.");
                IsSelectDateEnabled = true;
                return;
            }

            if (Directory.Exists($@"{_workingDirectory}"))
                Directory.Delete($@"{_workingDirectory}", true);

            Directory.CreateDirectory($@"{_workingDirectory}");

            IDownloadController downloadController = DownloadControllerFactory.Create(DownloadType.Earlinet, _earlinetRepositoryDirectory, _workingDirectory);
            await downloadController.Download(FromDate, ToDate,"BRC");


            downloadController = DownloadControllerFactory.Create(DownloadType.Aeronet, _aeronetRepositoryDirectory, _workingDirectory);
            await downloadController.Download(FromDate, ToDate, "Barcelona");

            Logger.Log("Updating dowloaded files list . . .");

            UpdateListOfFiles();

            Progress = "100";

            Logger.Log("Download completed.");

            IsSelectDateEnabled = true;
            IsDownloadedFilesVisible = true;
        }

        private bool CanDownload(object parameter)
        {
            return true;
        }

        #endregion

        #region Delete files

        public ICommand KeepSelectedFilesCmd => new RelayCommand(KeepSelectedFilesExecute, CanKeepSelectedFiles);

        private void KeepSelectedFilesExecute(object obj)
        {
            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"Executing: Keep selected files");
            var notSelected = DownloadedFiles_AERONET.Where(o => !o.IsChecked).Select(o => o.Name);
            if (notSelected.Any())
            {
                foreach (var file in notSelected)
                {
                    System.IO.File.Delete(System.IO.Path.Combine(_aeronetRepositoryDirectory,file));
                }
            }

            notSelected = DownloadedFiles_EARLINET.Where(o => !o.IsChecked).Select(o => o.Name);
            if (notSelected.Any())
            {
                foreach (var file in notSelected)
                {
                    System.IO.Directory.Delete(System.IO.Path.Combine(_earlinetRepositoryDirectory,file), true);
                }

            }

            DownloadedFiles_AERONET.Clear();
            DownloadedFiles_EARLINET.Clear();

            UpdateListOfFiles();
        }

        private bool CanKeepSelectedFiles(object _)
        {
            return true;
        }

        #endregion

        #endregion
    }
}
