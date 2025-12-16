using Avalonia.Controls;
using GRASP_Builder.ViewModels.ProjectActions;
using SkiaSharp;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Reflection.Metadata;
using System.Threading.Tasks;
using System.Windows.Input;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GRASP_Builder.ViewModels
{
    public class HomeProjectActionViewModel : ViewModelBase
    {
        #region Constructor

        public HomeProjectActionViewModel(string type)
        {
            switch (type)
            {
                case "Create":
                    _projectAction = new CreateProjectAction();
                    break;
                case "Open":
                    _projectAction = new OpenProjectAction();
                    break;
                case "Import":
                    _projectAction = new ImportProjectAction();
                    break;
                case "Export":
                    _projectAction = new ExportProjectAction();

                    DirectoryPath = AppConfig.Instance.GetValue("ProjectDirectoryPath");
                    _projectAction.DirectoryPath = DirectoryPath;
                    
                    ProjectName = new System.IO.DirectoryInfo(_projectAction.DirectoryPath).Name;
                    _projectAction.ProjectName = ProjectName;
                    break;
            }

            Title = _projectAction.Title;
            IsProjectNameVisible = _projectAction.IsProjectNameVisible;
            IsDirectoryPathVisible= _projectAction.IsDirectoryPathVisible;
        }

        #endregion

        #region Members
        private 
            IProjectAction _projectAction;

        #endregion

        #region Binding

        private bool _isProjectNameVisible = false;
        public bool IsProjectNameVisible
        {
            get => _isProjectNameVisible;
            set => SetProperty(ref _isProjectNameVisible, value);
        }

        private bool _isDirectoryPathVisible = false;
        public bool IsDirectoryPathVisible
        {
            get => _isDirectoryPathVisible;
            set => SetProperty(ref _isDirectoryPathVisible, value);
        }

        private string _projectName = "NewGRASPProject";
        public string ProjectName
        {
            get => _projectName;
            set => SetProperty(ref _projectName, value);
        }

        private string _title = string.Empty;
        public string Title
        {
            get => _title;
            set => SetProperty(ref _title, value);
        }

        private string _directoryPath = string.Empty;
        public string DirectoryPath
        {
            get => _directoryPath;
            set => SetProperty(ref _directoryPath, value);
        }

        #endregion

        #region Commands

        public ICommand BrowseCmd => new RelayCommand(async _ => await BrowseExecute(), CanBrowse);

        private bool CanBrowse(object _)
        {
            return true;
        }

        private async Task BrowseExecute()
        {
            _projectAction.DirectoryPath = DirectoryPath;
            _projectAction.ProjectName = ProjectName;

            await _projectAction.Browse();
            
            DirectoryPath = _projectAction.DirectoryPath;
            ProjectName = _projectAction.ProjectName;
        }

        public ICommand OKCmd => new RelayCommand(OKExecute, CanOK);
        private async void OKExecute(object _)
        {
            _projectAction.DirectoryPath = DirectoryPath;
            _projectAction.ProjectName = ProjectName;

            bool res = await _projectAction.Execute();

            if (res)
            {
                DirectoryPath = _projectAction.DirectoryPath;
                ProjectName = _projectAction.ProjectName;

                AppConfig.Instance.SetValue("ProjectDirectoryPath", DirectoryPath);
                AppConfig.Instance.SetValue("ProjectName", ProjectName);

                Messenger.Default.Send<bool>("UpdateProjectLoaded", true);
            }

            Messenger.Default.Send<bool>("CloseHomeProjectActionWindow", res);
        }

        private bool CanOK(object _)
        {
            return true;
        }

        #endregion
    }
}