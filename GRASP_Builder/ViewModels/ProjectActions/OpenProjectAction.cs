using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public class OpenProjectAction : IProjectAction
    {
        public string Title { get; set; } = "Open project from existing folder";
        public string DirectoryPath { get; set; }
        public string ProjectName { get; set; }
        public bool IsProjectNameVisible { get; set; } = false;

        public async Task Browse()
        {
            // Show folder picker (cross-platform via Avalonia)
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
            var dialog = new OpenFolderDialog
            {
                Title = "Select project folder"
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
                // default project name to last path segment
                ProjectName = Path.GetFileName(result.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));
            }
        }

        public void Execute()
        {
            try
            {
                if (string.IsNullOrWhiteSpace(DirectoryPath) || !Directory.Exists(DirectoryPath))
                {
                    Logger.Log($"OpenProject: directory does not exist: {DirectoryPath}");
                    return;
                }

                // Prefer explicit project marker file "project.grasp"
                var candidate = Path.Combine(DirectoryPath, "project.grasp");
                string projectRoot = DirectoryPath;
                if (!File.Exists(candidate))
                {
                    // search one level down for a folder that contains project.grasp
                    var subdirs = Directory.GetDirectories(DirectoryPath);
                    var found = subdirs.FirstOrDefault(d => File.Exists(Path.Combine(d, "project.grasp")));
                    if (found != null)
                    {
                        projectRoot = found;
                    }
                    else
                    {
                        Logger.Log($"OpenProject: no GRASP project marker (project.grasp) found in {DirectoryPath} or its immediate subfolders.");
                        return;
                    }
                }

                ProjectName = Path.GetFileName(projectRoot.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));
                Logger.Log($"Project opened at: {projectRoot}");
                // TODO: integrate with application state / project manager if available.
            }
            catch (Exception ex)
            {
                Logger.Log($"OpenProject failed: {ex.Message}");
            }
        }
    }
}
