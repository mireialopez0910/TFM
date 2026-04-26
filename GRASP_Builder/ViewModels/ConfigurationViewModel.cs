using GRASP_Builder.AppCode;
using GRASP_Builder.AppCode.DownloadControllers;
using GRASP_Builder.WebServices;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using System.Xml.Serialization;
using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;

namespace GRASP_Builder.ViewModels
{
    public class ConfigurationViewModel : ViewModelBase
    {

        #region Members
        
        private ProjectConfig projectCfg;
        private Dictionary<string,string> settingsToSave = new Dictionary<string, string>();

        #endregion

        #region Constructor

        public ConfigurationViewModel()
        {
            projectCfg = (App.Current as App)?.CurrentProjectConfig;
            LoadSettings();
        }

        private void LoadSettings()
        {
            AeronetRepositoryPath = projectCfg?.GetValue("AeronetRepositoryDirectory");
            EarlinetRepositoryPath = projectCfg?.GetValue("EarlinetRepositoryDirectory");
            GraspInstallPath = AppConfig.Instance.GetValue("GraspInstallPath");
            MatlabOutputDirectory = projectCfg?.GetValue("MatlabOutputDirectory");
        }

        #endregion

        #region Binding

        private string _MatlabProjectFilePath = AppConfig.Instance.GetValue("MatlabProjectFilePath");
        public string MatlabProjectFilePath
        {
            get => _MatlabProjectFilePath;
            set
            {
                SetProperty<string>(ref _MatlabProjectFilePath, value);
                AppConfig.Instance.SetValue("MatlabProjectFilePath", value);
            }
        }

        private string _MatlabOutputDirectory;
        public string MatlabOutputDirectory
        {
            get => _MatlabOutputDirectory;
            set
            {
                SetProperty<string>(ref _MatlabOutputDirectory, value);
                AppConfig.Instance.SetValue("MatlabOutputDirectory", value);
            }
        }

        private string _AeronetRepositoryPath;
        public string AeronetRepositoryPath
        {
            get => _AeronetRepositoryPath;
            set
            {
                SetProperty<string>(ref _AeronetRepositoryPath, value);
                AddParamToDictionary("AeronetRepositoryDirectory", value);
            }
        }

        private string _graspInstallPath=string.Empty;
        public string GraspInstallPath
        {
            get => _graspInstallPath;
            set
            {
                SetProperty<string>(ref _graspInstallPath, value);
                AddParamToDictionary("GraspInstallPath", value);
            }
        }

        private string _EarlinetRepositoryPath;
        public string EarlinetRepositoryPath
        {
            get => _EarlinetRepositoryPath;
            set
            {
                SetProperty<string>(ref _EarlinetRepositoryPath, value);
                AddParamToDictionary("EarlinetRepositoryDirectory", value);
            }
        }

        private void AddParamToDictionary(string key, string value)
        {
            if (settingsToSave.ContainsKey(key))
                settingsToSave.Remove(key);

            settingsToSave.Add(key, value);
        }

        #endregion

        #region Commands

        public ICommand SaveSettingsCmd=> new RelayCommand(SaveSettingsExecute, CanExecute);
        private void SaveSettingsExecute(object _)
        {
            foreach (var kvp in settingsToSave)
            {
                projectCfg.SetValue(kvp.Key, kvp.Value);
            }

            bool saved = projectCfg.Save();

            if (saved)
            {
                // Update the global/current project config so the rest of the app sees the saved values.
                if (App.Current is App app)
                {
                    app.CurrentProjectConfig = projectCfg;
                    // Optionally reload to ensure the in-memory instance is consistent with disk:
                    // app.CurrentProjectConfig.Reload();
                }

                settingsToSave.Clear();
            }
        }

        public ICommand ReloadStationsCmd=> new RelayCommand(ReloadStationsExecute, CanExecute);
        private void ReloadStationsExecute(object _)
        {
            ObservableCollection<string> stations = StationsService.GetStations();
            Messenger.Default.Send<ObservableCollection<string>>("UpdateStations", stations);
        }

        public ICommand SearchEarlinetDirCmd => new RelayCommand(async _ => await Task.Run(() => SearchEarlinetDirExecute(_)), CanExecute);
        private async void SearchEarlinetDirExecute(object _)
        {
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow as Window;

            string? folder = null;
            try
            {
                folder = await FileHelpers.SelectFolderAsync(window, "Select Earlinet repository directory");
            }
            catch
            {
                folder = null;
            }

            if (!string.IsNullOrWhiteSpace(folder))
            {
                EarlinetRepositoryPath = folder;
            }

        }

        public ICommand SearchAeronetDirCmd=> new RelayCommand(async _ => await Task.Run(() => SearchAeronetDirExecute(_)), CanExecute);
        private async void SearchAeronetDirExecute(object _)
        {
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow as Window;

            string? folder = null;
            try
            {
                folder = await FileHelpers.SelectFolderAsync(window, "Select Aeronet repository directory");
            }
            catch
            {
                folder = null;
            }

            if (!string.IsNullOrWhiteSpace(folder))
            {
                AeronetRepositoryPath = folder;
            }
        }

        public ICommand SearchGRASPInstallDirCmd=> new RelayCommand(async _ => await Task.Run(() => SearchGRASPInstallDirExecute(_)), CanExecute);
        private async void SearchGRASPInstallDirExecute(object _)
        {
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow as Window;

            string? folder = null;
            try
            {
                folder = await FileHelpers.SelectFolderAsync(window, "Select GRASP installation folder");
            }
            catch
            {
                folder = null;
            }

            if (!string.IsNullOrWhiteSpace(folder))
            {
                MatlabOutputDirectory = folder;
            }
        }

        public ICommand SearchMatlabOutputDirCmd=> new RelayCommand(async _ => await Task.Run(() => SearchMatlabOutputDirExecute(_)), CanExecute);
        private async void SearchMatlabOutputDirExecute(object _)
        {
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow as Window;

            string? folder = null;
            try
            {
                folder = await FileHelpers.SelectFolderAsync(window, "Select Matlab output folder");
            }
            catch
            {
                folder = null;
            }

            if (!string.IsNullOrWhiteSpace(folder))
            {
                MatlabOutputDirectory = folder;
            }
        }

        private bool CanExecute(object _)
        {
            return true;
        }

        #endregion
    }
}
