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
                AddParamToDictionary("AeronetRepositoryPath", value);
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
                AddParamToDictionary("EarlinetRepositoryPath", value);
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
            
            projectCfg.Save();
            settingsToSave.Clear();
        }

        public ICommand ReloadStationsCmd=> new RelayCommand(ReloadStationsExecute, CanExecute);
        private void ReloadStationsExecute(object _)
        {
            ObservableCollection<string> stations = StationsService.GetStations();
            Messenger.Default.Send<ObservableCollection<string>>("UpdateStations", stations);
        }

        private bool CanExecute(object _)
        {
            return true;
        }

        #endregion
    }
}
