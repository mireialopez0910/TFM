using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using GRASP_Builder.Views;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace GRASP_Builder.ViewModels
{
    public class HomeViewModel: ViewModelBase
    {
        #region Constructor
        string action = string.Empty;
        public HomeViewModel()
        {
            Messenger.Default.Register<string>("ExecuteHomeCommand", ExecuteHomeCommand);
        }

        public void ExecuteHomeCommand(string command)
        {
            switch (command)
            {
                case "Create":
                    CreateProjectCmd.Execute(null);
                    break;
                case "Open":
                    OpenProjectCmd.Execute(null);
                    break;
                case "Import":
                    ImportFromZipCmd.Execute(null);
                    break;
                case "Export":
                    action = "Export";
                    Execute();
                    break;
                default:
                    break;
            }
        }

        #endregion

        #region Commands

        public ICommand CreateProjectCmd => new RelayCommand(CreateProjectExecute, CanExecute);
        private async void CreateProjectExecute(object _)
        {
            action = "Create";
            Execute();
        }

        public ICommand OpenProjectCmd => new RelayCommand(OpenProjectExecute, CanExecute);
        private async void OpenProjectExecute(object _)
        {
            action = "Open";
            Execute();
        }
        
        public ICommand ImportFromZipCmd => new RelayCommand(ImportFromZipExecute, CanExecute);
        private void ImportFromZipExecute(object _)
        {
            action = "Import";
            Execute();
        }


        //All type execute same method and can be executed when buttons are visible
        private bool CanExecute(object _)
        {
            return true;
        }
        private async void Execute()
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;
            await ShowMyDialog(owner, action);
        }

        public async Task ShowMyDialog(Window owner, string type)
        {
            var dialog = new HomeProjectActionWindow(type);
            var result = await dialog.ShowDialog<bool>(owner);

            if (result)
            {

            }
            else
            {
                // User clicked Cancel
            }
        }

        #endregion
    }
}
