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
        public bool IsDirectoryPathVisible { get; set; } = true;
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

        public async Task<bool> Execute()
        {
            try
            {
                if (string.IsNullOrWhiteSpace(DirectoryPath) || !Directory.Exists(DirectoryPath))
                {
                    await Helpers.ShowMessage($"ERROR: Directory does not exist: {DirectoryPath}. Project can not be opened.", "No GRASP project marker", isError: true);
                    Logger.Log($"OpenProject: directory does not exist: {DirectoryPath}");
                    return false;
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
                        await Helpers.ShowMessage($"ERROR:no GRASP project marker (project.grasp) found in {DirectoryPath} or its immediate subfolders.", "Directory does not exist", isError: true);
                        Logger.Log($"OpenProject: no GRASP project marker (project.grasp) found in {DirectoryPath} or its immediate subfolders.");
                        return false;
                    }
                }

                ProjectName = Path.GetFileName(projectRoot.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));
                Logger.Log($"Project opened at: {projectRoot}");
                return true;
                // TODO: integrate with application state / project manager if available.
            }
            catch (Exception ex)
            {
                Logger.Log($"OpenProject failed: {ex.Message}");
                return false;
            }
        }
    }
}
