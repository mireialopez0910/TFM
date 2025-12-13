using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using System;
using System.IO;
using System.IO.Compression;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public class ExportProjectAction : IProjectAction
    {
        public string Title { get; set; } = "Export project to zip file";
        public string DirectoryPath { get; set; }    // will hold the selected project folder path
        public string ProjectName { get; set; }
        public bool IsProjectNameVisible { get; set; } = true;
        public bool IsDirectoryPathVisible { get; set; } = false;

        public async Task Browse()
        {
            // Let the user pick the folder that contains the project to export
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
            var dialog = new OpenFolderDialog
            {
                Title = "Select project folder to export"
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
                // default project name to last path segment so user can edit it in the UI
                ProjectName = Path.GetFileName(result.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));
            }
        }

        public void Execute()
        {
            if (string.IsNullOrWhiteSpace(DirectoryPath) || !Directory.Exists(DirectoryPath))
            {
                Logger.Log($"ExportProject: project folder not found: {DirectoryPath}");
                return;
            }

            try
            {
                // determine destination zip file (place next to the project folder)
                var projectFolder = DirectoryPath.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
                var parentDir = Path.GetDirectoryName(projectFolder) ?? Directory.GetCurrentDirectory();

                var finalName = !string.IsNullOrWhiteSpace(ProjectName)
                    ? ProjectName
                    : Path.GetFileName(projectFolder);

                var zipPath = Path.Combine(parentDir, finalName + ".zip");

                // make sure we are not creating the zip inside the source folder (would cause issues)
                if (zipPath.StartsWith(projectFolder + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase) ||
                    string.Equals(zipPath, Path.Combine(projectFolder, Path.GetFileName(zipPath)), StringComparison.OrdinalIgnoreCase))
                {
                    Logger.Log("ExportProject: destination zip would be inside source folder. Choose a different location.");
                    return;
                }

                // overwrite existing zip if present
                if (File.Exists(zipPath))
                {
                    try
                    {
                        File.Delete(zipPath);
                    }
                    catch (Exception ex)
                    {
                        Logger.Log($"ExportProject: unable to remove existing zip {zipPath}: {ex.Message}");
                        return;
                    }
                }

                // include the base directory so the zip contains a top-level project folder (matching import expectations)
                ZipFile.CreateFromDirectory(projectFolder, zipPath, CompressionLevel.Optimal, includeBaseDirectory: true);

                Logger.Log($"Project exported to: {zipPath}");
            }
            catch (Exception ex)
            {
                Logger.Log($"ExportProject failed: {ex.Message}");
            }
        }
    }
}