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

        public HomeViewModel()
        {

        }

        #endregion

        #region Commands

        public ICommand CreateProjectCmd => new RelayCommand(CreateProjectExecute, CanCreateProject);
        private async void CreateProjectExecute(object _)
        {
            await CreateProject();
        }
        private bool CanCreateProject(object _)
        {
            return true;
        }

        private async Task CreateProject()
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;
            await ShowMyDialog(owner, "Create");
        }

        public ICommand OpenProjectCmd => new RelayCommand(OpenProjectExecute, CanOpenProject);
        private async void OpenProjectExecute(object _)
        {
            OpenProject();
        }
        private bool CanOpenProject(object _)
        {
            return true;
        }

        private async Task OpenProject()
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;
            await ShowMyDialog(owner,"Open");
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

        public ICommand ImportFromZipCmd => new RelayCommand(ImportFromZipExecute, CanImportFromZip);
        private void ImportFromZipExecute(object _)
        {
            ImportFromZip();
        }
        private bool CanImportFromZip(object _)
        {
            return true;
        }
        private async Task ImportFromZip()
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;
            await ShowMyDialog(owner, "Import");
        }

        #endregion
    }
}
