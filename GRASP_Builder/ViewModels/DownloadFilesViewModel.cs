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
using Tmds.DBus.Protocol;

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

            _earlinetClient = new EarlinetService();
            _aeronetService = new AeronetService();

            Messenger.Default.Register<object>("UpdateAppTitle", UpdateAppTitle);
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

        private void UpdateAppTitle(object obj)
        {
            _workingDirectory = AppConfig.Instance.GetValue("WorkingDirectory");
            if (System.IO.Directory.Exists(_workingDirectory))
                System.IO.Directory.Delete(_workingDirectory, true);
            System.IO.Directory.CreateDirectory(_workingDirectory);

            _repositoryDirectory = $@"{AppConfig.Instance.GetValue("ProjectDirectoryPath")}/Data/";

            _aeronetRepositoryDirectory = $@"{_repositoryDirectory}AERONET/";
            if (!System.IO.Directory.Exists(_aeronetRepositoryDirectory))
                System.IO.Directory.CreateDirectory(_aeronetRepositoryDirectory);


            _earlinetRepositoryDirectory = $@"{_repositoryDirectory}LIDAR/";
            if (!System.IO.Directory.Exists(_earlinetRepositoryDirectory))
                System.IO.Directory.CreateDirectory(_earlinetRepositoryDirectory);


            UpdateListOfFiles();
            if (DownloadedFiles_AERONET.Count > 0 || DownloadedFiles_EARLINET.Count > 0)
            {
                IsSelectDateEnabled = true;
                IsDownloadedFilesVisible = true;
            }
        }

        #endregion

        #region Methods


        private void UpdateFiles(List<string> fileNames, FileType fileType)
        {
            ObservableCollection<string> _measureIDList = new ObservableCollection<string>();
            foreach (string file in fileNames)
            {
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
        }

        private bool AddToMeasureIDList(string folder)
        {

            List<string> files = GetAllFiles(folder);
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

            foreach (FileType type in Enum.GetValues(typeof(FileType)))
            {
                if (type != FileType.ELPP && type != FileType.Optical)
                {

                    List<string> list = GetAllFiles(_aeronetRepositoryDirectory);

                    UpdateFiles(list, type);
                }
                else
                {
                    List<string> list = GetAllFolders(_earlinetRepositoryDirectory);
                    UpdateFiles(list, type);
                }
            }
        }

        #endregion

        #region Commands

        #region Download files

        public ICommand DownloadCmd => new RelayCommand(async _ => await DownloadExecute(), CanDownload);

        private async Task<string> DownloadEarlinetExecute()
        {
            try
            {

                Directory.Delete(_earlinetRepositoryDirectory, true);
                Directory.CreateDirectory(_earlinetRepositoryDirectory);

                string date = DateTime.Now.ToString("dd_MM_yyyy__hh_mm");

                Logger.Log($"Downloading EARLINET-OPTICAL data");
                
                bool res_elda = await _earlinetClient.DownloadProductByDateRangeAsync("OPTICAL", FromDate.ToString("yyyy-MM-dd"), ToDate.ToString("yyyy-MM-dd"), $"{_workingDirectory}EARLINET_ELDA_{date}.zip");
                if (res_elda)
                    Logger.Log($"Data downloaded correctly and saved in file {_workingDirectory}EARLINET_ELDA_{{date}}.zip");
                else
                    Logger.Log($"ELDA Data was not downloaded correctly");

                Progress = "15";
                Logger.Log($"Downloading EARLINET-ELPP data");
                
                bool res_elpp = await _earlinetClient.DownloadProductByDateRangeAsync("ELPP", FromDate.ToString("yyyy-MM-dd"), ToDate.ToString("yyyy-MM-dd"), $"{_workingDirectory}EARLINET_ELPP_{date}.zip");
                if (res_elpp)
                    Logger.Log($"Data downloaded correctly and saved in file {_workingDirectory}EARLINET_ELPP_{date}.zip");
                else
                    Logger.Log($"ELPP Data was not downloaded correctly");
                
                return date;
            }
            catch (Exception ex)
            {
                Logger.Log($"Exception: {ex.Message}");
            }

            return null;
        }

        private async Task DownloadAeronetExecute()
        {
            Directory.Delete(_aeronetRepositoryDirectory, true);
            Directory.CreateDirectory(_aeronetRepositoryDirectory);

            Logger.Log($"Downloading Aeronet files from date {FromDate.ToString("dd-MM-yyyy")}");

            string url = _aeronetService.BuildUrl(DataType.AerosolInversions, FromDate, ToDate);

            string destinationFile = $@"{_aeronetRepositoryDirectory}{FileType.AeronetInversions.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.all";

            await _aeronetService.DescargarDatosAsync(destinationFile, url);
            Logger.Log($"{_workingDirectory}aeronet Aerosol inversion products data have downloaded and saved in file {destinationFile}");

            Progress = "50";

            url = _aeronetService.BuildUrl(DataType.OpticalDepth, FromDate, ToDate, "AOD15");

            destinationFile = $@"{_aeronetRepositoryDirectory}{FileType.AeronetAOD.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.lev15";

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.lev15

            Logger.Log($"{_workingDirectory}aeronet AOD data have been downloaded and saved in file {destinationFile}");

            Progress = "60";

            url = _aeronetService.BuildUrl(DataType.OpticalDepth, FromDate, ToDate, "SDA15");

            destinationFile = $@"{_aeronetRepositoryDirectory}{FileType.AeronetSDA.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.ONEILL_lev15";

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.ONEILL_lev15

            Logger.Log("AERONET Spectral deconvolution algortihm file downloaded & saved in file: " + destinationFile);

            Progress = "70";

            url = _aeronetService.BuildUrl(DataType.RawProductsOpticalDepth, FromDate, ToDate, RawProductsOpticalDepth.ALM00);

            destinationFile = $@"{_aeronetRepositoryDirectory}{FileType.AeronetRawAlmucantar.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.alm";

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.alm
            Progress = "80";

            Logger.Log($"{_workingDirectory}aeronet Raw Almucantar data have been downloaded and saved in file {destinationFile}");

            url = _aeronetService.BuildUrl(DataType.RawProductsOpticalDepth, FromDate, ToDate, RawProductsOpticalDepth.ALP00);

            destinationFile = $@"{_aeronetRepositoryDirectory}{FileType.AeronetRawPolarizedAlmucantar.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.alp";

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.alp
            Progress = "90";

            Logger.Log($"{_workingDirectory}aeronet Raw polarized almucantar has been downloaded and saved in file {destinationFile}");
        }

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

            if (Directory.Exists($@"{_workingDirectory}/Data/"))
                Directory.Delete($@"{_workingDirectory}/Data/", true);

            Directory.CreateDirectory($@"{_workingDirectory}/Data/");

            string date = await DownloadEarlinetExecute();

            Progress = "30";

            Logger.Log("Unzipping EARLINET files . . .");

            foreach (string file in GetAllFiles($@"{_workingDirectory}"))
            {
                if (file.Contains(date) && file.EndsWith(".zip"))
                {
                    //extract earlinet files
                    string folder = file.Replace(".zip", "");
                    UnzipFile(file, folder);

                    List<string> downloadedFolders = GetAllNestedFolders(folder);
                    string nestedFolder = downloadedFolders.FirstOrDefault();

                    List<string> folders = GetAllNestedFolders(nestedFolder);


                    foreach (string f in folders)
                    {
                        if (!f.EndsWith("elpp") && !f.EndsWith("opticalproducts") && !f.EndsWith("optical_products"))
                        {
                            string[] f_splitted = f.Split(System.IO.Path.DirectorySeparatorChar);

                            string dest_folder = @$"{_earlinetRepositoryDirectory}{f_splitted[^1]}";

                            if (!Directory.Exists(dest_folder))
                                Directory.CreateDirectory(dest_folder);

                            foreach (var ncFile in Directory.GetFiles(f, "*.*", System.IO.SearchOption.AllDirectories))
                            {
                                string[] pathSplited = ncFile.Replace(@"\", @"/").Split(@"/");
                                string relative = pathSplited[pathSplited.Length - 1];
                                string destination = string.Empty;
                                
                                if (!file.Contains("ELPP"))
                                    destination = System.IO.Path.Combine(dest_folder, relative.Split(".")[0] + "_elda.nc");
                                else
                                    destination = System.IO.Path.Combine(dest_folder, relative);

                                Directory.CreateDirectory(System.IO.Path.GetDirectoryName(destination)!);
                                File.Copy(ncFile, destination, overwrite: true);
                                Logger.Log($"File {ncFile} saved in folder: {destination}");
                            }

                        }
                    }

                }
            }

            Progress = "40";

            await DownloadAeronetExecute();

            Logger.Log("Updating dowloaded files list . . .");

            UpdateListOfFiles();

            Progress = "100";

            Logger.Log("Download completed.");
            IsSelectDateEnabled = true;
            IsDownloadedFilesVisible = true;
        }
        public static List<string> GetAllNestedFolders(string rootDir)
        {
            var result = new List<string>();
            if (Directory.Exists(rootDir))
            {
                foreach (var dir in Directory.GetDirectories(rootDir))
                {
                    result.Add(dir);

                    foreach (var subDir in Directory.GetDirectories(dir))
                    {
                        result.Add(subDir);
                    }
                }
            }

            return result;
        }

        private static void UnzipFile(string zipPath, string extractPath)
        {
            try
            {
                if (File.Exists(zipPath))
                    ZipFile.ExtractToDirectory(zipPath, extractPath);
            }
            catch (InvalidDataException ex)
            {
                using (StreamWriter sw = new StreamWriter("log.txt", true))
                    Logger.Log("no files where downloaded for selected dates range");
            }
            catch (Exception ex)
            {
                using (StreamWriter sw = new StreamWriter("log.txt", true))
                    Logger.Log($"Exception: {ex.Message}");
            }
        }

        private static List<string> GetAllFiles(string directoryPath)
        {
            if (!Directory.Exists(directoryPath))
                System.IO.Directory.CreateDirectory(directoryPath);

            var files = Directory.GetFiles(directoryPath, "*", System.IO.SearchOption.AllDirectories);
            return new List<string>(files);
        }

        private static List<string> GetAllFolders(string directoryPath)
        {
            if (!Directory.Exists(directoryPath))
                System.IO.Directory.CreateDirectory(directoryPath);

            var directories = Directory.GetDirectories(directoryPath, "*", System.IO.SearchOption.AllDirectories);
            return new List<string>(directories);
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
            var notSelected = DownloadedFiles_AERONET.Where(o => !o.IsChecked).Select(o => o.Name);
            if (notSelected.Any())
            {
                foreach (var file in notSelected)
                {
                    System.IO.File.Delete($@"{_aeronetRepositoryDirectory}{file}");
                }
            }

            notSelected = DownloadedFiles_EARLINET.Where(o => !o.IsChecked).Select(o => o.Name);
            if (notSelected.Any())
            {
                foreach (var file in notSelected)
                {
                    System.IO.Directory.Delete($@"{_earlinetRepositoryDirectory}{file}", true);
                }

            }

            DownloadedFiles_AERONET.Clear();
            DownloadedFiles_EARLINET.Clear();

            UpdateListOfFiles();
        }

        private bool CanKeepSelectedFiles(object _)
        {
            var selectedAeronet = DownloadedFiles_AERONET.Where(o => o.IsChecked).Select(o => o.Name);
            var selectedEarlinet = DownloadedFiles_EARLINET.Where(o => o.IsChecked).Select(o => o.Name);
            return selectedAeronet.Any() || selectedEarlinet.Any();
        }

        #endregion

        #endregion
    }
}
