using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public class CreateProjectAction : IProjectAction
    {
        public string Title { get; set; } = "Create new project";
        public string DirectoryPath { get; set; }
        public string ProjectName { get; set; } = "NewGRASPProject";
        public bool IsProjectNameVisible { get; set; } = true;
        public bool IsDirectoryPathVisible { get; set; } = true;
        public async Task Browse()
        {
            // parameter is expected to be an Avalonia.Controls.Window (the owner). If null the dialog will be shown without owner.
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
            var dialog = new OpenFolderDialog
            {
                Title = "Select folder to create the project in"
            };

            string? result;
            try
            {
                result = await dialog.ShowAsync(window);
            }
            catch
            {
                result = null;
            }

            if (!string.IsNullOrWhiteSpace(result))
            {
                DirectoryPath = result;
            }
        }

        public async Task<bool> Execute() //Create project in DirectoryPath 
        {
            try
            {
                // create the project directory
                var projectRoot = Path.Combine(DirectoryPath, ProjectName);
                if (!Directory.Exists(projectRoot))
                {
                    Directory.CreateDirectory(projectRoot);
                }
                // optional: create a placeholder file
                var placeholder = Path.Combine(projectRoot, "project.grasp");
                if (!File.Exists(placeholder))
                {
                    File.WriteAllText(placeholder, $"# GRASP project: {ProjectName}{Environment.NewLine}");
                }

                Logger.Log($"Project created at:{Environment.NewLine}{projectRoot}");
                return true;
            }
            catch (Exception ex)
            {
                await Helpers.ShowMessage($"ERROR: Failed to create project: {ex.Message}.", "Failed to create project", isError: true);
                Logger.Log($"Failed to create project: {ex.Message}");
                return false;
            }
        }
    }
}
