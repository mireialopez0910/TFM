using CommunityToolkit.Mvvm.Messaging;
using GRASP_Builder.UIElement;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;


namespace GRASP_Builder.ViewModels
{
    public partial class MainWindowViewModel : ViewModelBase
    {
        #region Constructor

        public MainWindowViewModel()
        {
            Messenger.Default.Register<object>("UpdateAppTitle", UpdateAppTitle);
        }

        private void UpdateAppTitle(object obj)
        {
            Title= $"GRASP Builder: {AppConfig.Instance.GetValue("ProjectName")}";
        }

        #endregion

        #region Binding

        private string _title = "GRASP Builder";
        public string Title
        {
            get => _title;
            set => SetProperty(ref _title, value);
        }

        #endregion

        #region Commands   

        #endregion
    }
}
