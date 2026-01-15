using Avalonia.Input;
using Avalonia.Platform;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Runtime.Intrinsics.X86;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GRASP_Builder.ViewModels
{
    public class DataCombinationViewModel : ViewModelBase
    {
        #region Constructor

        public DataCombinationViewModel()
        {
            Messenger.Default.Register<ObservableCollection<string>>("UpdateMeasureIDList", UpdateMeasureIDList);
            Messenger.Default.Register<Dictionary<string, string>>("UpdateUI", UpdateUI);
            Messenger.Default.Register<bool>("UpdateButtonsEnabled", UpdateButtonsEnabled);
            Messenger.Default.Register<bool>("UpdateProjectLoaded", UpdateProjectLoaded);
        }

        #endregion

        #region Messenger

        private void UpdateMeasureIDList(ObservableCollection<string> list)
        {
            MeasureIDOptions = list;
        }

        private void UpdateUI(Dictionary<string, string> dic)
        {
            foreach (KeyValuePair<string, string> kvp in dic)
            {
                switch (kvp.Key)
                {
                    case "heightLimitMin":
                        hMin = kvp.Value; break;
                    case "heightLimitMax":
                        hMax = kvp.Value; break;
                    case "D1_L":
                        isEnabled_D1_L = isEnabled(kvp.Value);
                        break;
                    case "D1P_L":
                        isEnabled_D1P_L = isEnabled(kvp.Value);
                        break;
                    case "D1_L_VD":
                        isEnabled_D1_L_VD = isEnabled(kvp.Value);
                        break;
                    case "D1P_L_VD":
                        isEnabled_D1P_L_VD = isEnabled(kvp.Value);
                        break;
                    default:
                        break;
                }
            }

            UpdateButtonsEnabled(true);
        }

        private void UpdateButtonsEnabled(bool status)
        {
            AreButtonsEnabled = status;
            if (!status)
            {
                isEnabled_D1_L = false;
                isEnabled_D1P_L = false;
                isEnabled_D1_L_VD = false;
                isEnabled_D1P_L_VD = false;
            }
            else
            {
                if (!isEnabled_D1_L_VD && !isEnabled_D1P_L_VD)
                {
                    isOptionVDEnabled = false;
                    IsOptionELPP = true;
                }
                else isOptionVDEnabled = true;
            }
        }

        private bool isEnabled(string v) { return v == "enabled"; }


        private void UpdateProjectLoaded(bool obj)
        {
            var projectCfg = (App.Current as App)?.CurrentProjectConfig;

            _aeronetRepositoryDirectory = projectCfg?.GetValue("AeronetRepositoryDirectory");
            _earlinetRepositoryDirectory = projectCfg?.GetValue("EarlinetRepositoryDirectory");

            SelectedMeasureID = string.Empty;
        }

        #endregion

        #region Members

        string _aeronetRepositoryDirectory = string.Empty;
        string _earlinetRepositoryDirectory = string.Empty;


        #endregion

        #region Binding

        private string _selectedMeasureID = string.Empty;
        public string SelectedMeasureID
        {
            get => _selectedMeasureID;
            set
            {
                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"Selected measure ID value modified to: {value}");
                SetProperty<string>(ref _selectedMeasureID, value);
                if (!string.IsNullOrEmpty(value))
                    SelectedDate = new DateTime(year: Convert.ToInt32(_selectedMeasureID.Substring(0, 4)), month: Convert.ToInt32(_selectedMeasureID.Substring(4, 2)), day: Convert.ToInt32(_selectedMeasureID.Substring(6, 2)));
            }
        }

        private DateTime _selectedDate;
        public DateTime SelectedDate
        {
            get => _selectedDate;
            set
            {
                SetProperty<DateTime>(ref _selectedDate, value);

                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"Selected date value modified to {value}");

                GetHeightsMatlab();
            }
        }

        private ObservableCollection<string> _measureIDOptions = new ObservableCollection<string>();
        public ObservableCollection<string> MeasureIDOptions
        {
            get => _measureIDOptions;
            set => SetProperty<ObservableCollection<string>>(ref _measureIDOptions, value);
        }

        private string _hMax = "0";
        public string hMax
        {
            get => _hMax;
            set
            {
                SetProperty<string>(ref _hMax, value);
                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"h max value modified to {hMax}");
            }
        }

        private string _hMin = "0";
        public string hMin
        {
            get => _hMin;
            set
            {
                SetProperty<string>(ref _hMin, value);
                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"h min value modified to {hMin}");
            }
        }

        private bool _IsConfigSelectionEnabled = false;
        public bool IsConfigSelectionEnabled
        {
            get => _IsConfigSelectionEnabled;
            set => SetProperty<bool>(ref _IsConfigSelectionEnabled, value);
        }

        private bool _isOptionVDEnabled = false;
        public bool isOptionVDEnabled
        {
            get => _isOptionVDEnabled;
            set => SetProperty<bool>(ref _isOptionVDEnabled, value);
        }

        private bool _IsOptionELPP = true;
        public bool IsOptionELPP
        {
            get => _IsOptionELPP;
            set => SetProperty<bool>(ref _IsOptionELPP, value);
        }

        private bool _isChecked_D1_L = false;
        public bool isChecked_D1_L
        {
            get => _isChecked_D1_L;
            set
            {
                SetProperty<bool>(ref _isChecked_D1_L, value);

                if (AppConfig.Instance.IsDebugging())
                {
                    if (value)
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1_L option checked");
                    }
                    else
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1_L option unchecked");
                    }
                }
            }
        }

        private bool _isChecked_D1P_L = false;
        public bool isChecked_D1P_L
        {
            get => _isChecked_D1P_L;
            set
            {
                SetProperty<bool>(ref _isChecked_D1P_L, value);

                if (AppConfig.Instance.IsDebugging())
                {
                    if (value)
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1P_L option checked");
                    }
                    else
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1P_L option unchecked");
                    }
                }
            }
        }

        private bool _isChecked_D1_L_VD = false;
        public bool isChecked_D1_L_VD
        {
            get => _isChecked_D1_L_VD;
            set
            {
                SetProperty<bool>(ref _isChecked_D1_L_VD, value);
                if (AppConfig.Instance.IsDebugging())
                {
                    if (value)
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1_L_VD option checked");
                    }
                    else
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1_L_VD option unchecked");
                    }
                }
            }
        }
        private bool _isChecked_D1P_L_VD = false;
        public bool isChecked_D1P_L_VD
        {
            get => _isChecked_D1P_L_VD;
            set
            {
                SetProperty<bool>(ref _isChecked_D1P_L_VD, value);

                if (AppConfig.Instance.IsDebugging())
                {
                    if (value)
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1P_L_VD option checked");
                    }
                    else
                    {
                        if (AppConfig.Instance.IsDebugging())
                            Logger.Log($"D1P_L_VD option unchecked");
                    }
                }
            }
        }

        private bool _isEnabled_D1_L = false;
        public bool isEnabled_D1_L
        {
            get => _isEnabled_D1_L;
            set
            {
                SetProperty<bool>(ref _isEnabled_D1_L, value);
                if (!value)
                    isChecked_D1_L = false;
            }
        }

        private bool _isEnabled_D1P_L = false;
        public bool isEnabled_D1P_L
        {
            get => _isEnabled_D1P_L;
            set
            {
                SetProperty<bool>(ref _isEnabled_D1P_L, value);
                if (!value)
                    isChecked_D1P_L = false;
            }
        }

        private bool _isEnabled_D1_L_VD = false;
        public bool isEnabled_D1_L_VD
        {
            get => _isEnabled_D1_L_VD;
            set
            {
                SetProperty<bool>(ref _isEnabled_D1_L_VD, value);
                if (!value)
                    isChecked_D1_L_VD = false;
            }
        }

        private bool _isEnabled_D1P_L_VD = false;
        public bool isEnabled_D1P_L_VD
        {
            get => _isEnabled_D1P_L_VD;
            set
            {
                SetProperty<bool>(ref _isEnabled_D1P_L_VD, value);
                if (!value)
                    isChecked_D1_L_VD = false;
            }
        }

        private bool _areButtonsEnabled = true;
        public bool AreButtonsEnabled
        {
            get => _areButtonsEnabled;
            set => SetProperty<bool>(ref _areButtonsEnabled, value);
        }

        #endregion

        #region Commands

        public ICommand PlotPreviewCmd => new RelayCommand(PlotPreviewExecute, CanExecute);
        private void PlotPreviewExecute(object _)
        {
            PreviewMatlab();
        }

        private void PreviewMatlab(bool measureIDModified = false)
        {
            var dict = new Dictionary<string, object>
                    {
                        { "preview", "true" },
                        { "sendData", "false"},
                        { "selected_measure_ID", SelectedMeasureID},
                        {"plot_ELPP", IsOptionELPP.ToString().ToLower() },
                        {"Folder_AERONET", Path.Combine(_aeronetRepositoryDirectory, new string(SelectedMeasureID.Where(c => !char.IsDigit(c)).ToArray()).ToUpper())},
                        {"Folder_LIDAR",$@"{Path.Combine(_earlinetRepositoryDirectory, new string(SelectedMeasureID.Where(c => !char.IsDigit(c)).ToArray()).ToUpper())}/"},
                    };

            if (!measureIDModified)
            {
                dict.Add("heightLimitMax", hMax);
                dict.Add("heightLimitMin", hMin);
            }


            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"Preview Matlab script started with dicctionary: {FormatHelpers.DictionaryToString(dict)}");

            MatlabController.RunMatlabScript(ScriptType.Preview, dict, "_DC");

            IsConfigSelectionEnabled = true;
        }

        private void GetHeightsMatlab(bool measureIDModified = false)
        {
            var dict = new Dictionary<string, object>
                    {
                        {"preview", "false" },
                        {"sendData", "false"},
                        {"selected_measure_ID", SelectedMeasureID},
                        {"Folder_AERONET", Path.Combine(_aeronetRepositoryDirectory, new string(SelectedMeasureID.Where(c => !char.IsDigit(c)).ToArray()).ToUpper())},
                        {"Folder_LIDAR",$@"{Path.Combine(_earlinetRepositoryDirectory, new string(SelectedMeasureID.Where(c => !char.IsDigit(c)).ToArray()).ToUpper())}/"},
                    };

            if (!measureIDModified)
            {
                dict.Add("heightLimitMax", hMax);
                dict.Add("heightLimitMin", hMin);
            }


            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"GetHeights Matlab script started with dicctionary: {FormatHelpers.DictionaryToString(dict)}");

            MatlabController.RunMatlabScript(ScriptType.GetHeights, dict, "_DC");

            IsConfigSelectionEnabled = true;
        }


        public ICommand SendDataCmd => new RelayCommand(SendDataExecute, CanExecute);
        private void SendDataExecute(object _)
        {
            SendData();
        }

        private void SendData()
        {
            if (isChecked_D1_L || isChecked_D1_L_VD || isChecked_D1P_L || isChecked_D1P_L_VD)
            {
                var projectCfg = (App.Current as App)?.CurrentProjectConfig;

                var dict = new Dictionary<string, object>
                    {
                        { "preview", "false" },
                        { "sendData", "true"},
                        { "selected_measure_ID", SelectedMeasureID},
                        {"plot_ELPP", IsOptionELPP },
                        {"heightLimitMax",hMax  },
                        {"heightLimitMin",hMin  },
                        {"Folder_AERONET", Path.Combine(_aeronetRepositoryDirectory,new string(SelectedMeasureID.Where(c => !char.IsDigit(c)).ToArray()).ToUpper())},
                        {"Folder_LIDAR", $@"{Path.Combine(_earlinetRepositoryDirectory, new string(SelectedMeasureID.Where(c => !char.IsDigit(c)).ToArray()).ToUpper())}/"},
                        {"is_D1_L_checked",isChecked_D1_L },
                        {"is_D1P_L_checked",isChecked_D1P_L },
                        {"is_D1P_L_VD_checked",isChecked_D1P_L_VD },
                        {"is_D1_L_VD_checked",isChecked_D1_L_VD },
                        {"output_dir",$@"{projectCfg?.GetValue("MatlabOutputDirectory")}" }
                    };

                if (AppConfig.Instance.IsDebugging())
                    Logger.Log($"Send Data Matlab script started with dicctionary: {FormatHelpers.DictionaryToString(dict)}");

                MatlabController.RunMatlabScript(ScriptType.SendFiles, dict, "_DC");

                Messenger.Default.Send<object>("ReloadMeasureID", null);
            }
            else
                Logger.Log("ERROR: No data option selected to send.");
            IsConfigSelectionEnabled = true;
        }

        private bool CanExecute(object _)
        {
            return true;
        }

        #endregion
    }
}
