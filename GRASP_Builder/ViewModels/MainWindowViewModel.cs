using Avalonia.Controls.ApplicationLifetimes;
using CommunityToolkit.Mvvm.Messaging;
using GRASP_Builder.UIElement;
using GRASP_Builder.Views;
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
            Messenger.Default.Register<bool>("UpdateProjectLoaded", UpdateProjectLoaded);
        }

        private void UpdateProjectLoaded(bool projectLoaded)
        {
            if (projectLoaded)
                Title = $"GRASP Builder: {AppConfig.Instance.GetValue("ProjectName")}";
            
            else
                Title = "GRASP Builder";
            
            IsProjectLoaded = projectLoaded;
        }

        #endregion

        #region Binding

        private string _title = "GRASP Builder";
        public string Title
        {
            get => _title;
            set => SetProperty(ref _title, value);
        }

        private bool _isProjectLoaded = false;
        public bool IsProjectLoaded
        {
            get => _isProjectLoaded;
            set
            {
                SetProperty(ref _isProjectLoaded, value);
                IsHomeVisible = !value;
            }
        }

        private bool _isHomeVisible = true;
        public bool IsHomeVisible
        {
            get => _isHomeVisible;
            set => SetProperty(ref _isHomeVisible, value);
        }
        #endregion

        #region Commands   

        //All commands can be executed when menu is visible
        private bool CanExecute(object _)
        {
            return true;
        }

        public ICommand CreateCmd => new RelayCommand(CreateExecute, CanExecute);
        private async void CreateExecute(object _)
        {
            Messenger.Default.Send("ExecuteHomeCommand", "Create");
        }

        public ICommand OpenCmd => new RelayCommand(OpenExecute, CanExecute);
        private async void OpenExecute(object _)
        {
            Messenger.Default.Send("ExecuteHomeCommand", "Open");
        }

        public ICommand ImportCmd => new RelayCommand(ImportExecute, CanExecute);
        private async void ImportExecute(object _)
        {
            Messenger.Default.Send("ExecuteHomeCommand", "Import");
        }

        public ICommand ExportCmd => new RelayCommand(ExportExecute, CanExecute);
        private async void ExportExecute(object _)
        {
            Messenger.Default.Send("ExecuteHomeCommand", "Export");
        }

        public ICommand CloseCmd => new RelayCommand(CloseExecute, CanExecute);
        private async void CloseExecute(object _)
        {
            UpdateProjectLoaded(false);
        }
        public ICommand SettingsCmd => new RelayCommand(SettingsExecute, CanExecute);
        private async void SettingsExecute(object _)
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;

            var dialog = new SettingsWindow();
            var result = await dialog.ShowDialog<bool>(owner);
        }

        public ICommand AboutCmd => new RelayCommand(AboutExecute, CanExecute);
        private async void AboutExecute(object _)
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;

            var dialog = new AboutWindow();
            var result = await dialog.ShowDialog<bool>(owner);
        }
        public ICommand ChangeToSmallUI => new RelayCommand(ChangeToSmallUIExecute, CanExecute);
        private async void ChangeToSmallUIExecute(object _)
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;

            var newMainWindow = new SMainWindow();

            // Mostrarla
            newMainWindow.Show();

            // Cerrar la ventana actual
            desktop.MainWindow.Close();

            // Establecer la nueva ventana como principal
            desktop.MainWindow = newMainWindow;
        }
        public ICommand ChangeToFullUI => new RelayCommand(ChangeToFullUIExecute, CanExecute);
        private async void ChangeToFullUIExecute(object _)
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;

            var newMainWindow = new MainWindow();

            // Mostrarla
            newMainWindow.Show();
            // Cerrar la ventana actual
            desktop.MainWindow.Close();

            // Establecer la nueva ventana como principal
            desktop.MainWindow = newMainWindow;
        }
        #endregion
    }
}
