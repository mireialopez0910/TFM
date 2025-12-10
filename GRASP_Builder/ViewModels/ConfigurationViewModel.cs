using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels
{
    public class ConfigurationViewModel : ViewModelBase
    {
        #region Constructor

        public ConfigurationViewModel()
        {
            
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

        #endregion
    }
}
