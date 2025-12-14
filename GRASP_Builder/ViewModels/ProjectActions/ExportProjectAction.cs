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

        public async Task<bool> Execute()
        {
            if (string.IsNullOrWhiteSpace(DirectoryPath) || !Directory.Exists(DirectoryPath))
            {
                await Helpers.ShowMessage($"ERROR: ExportProject: project folder not found: {DirectoryPath}", "Project folder not found", isError: true);
                Logger.Log($"ExportProject: project folder not found: {DirectoryPath}");
                return false;
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
                    await Helpers.ShowMessage($"ERROR: Destination zip would be inside source folder. Choose a different location.", "Invalid location", isError: true);
                    Logger.Log("ExportProject: destination zip would be inside source folder. Choose a different location.");
                    return false;
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
                        await Helpers.ShowMessage($"ERROR: Unable to remove existing zip {zipPath}: {ex.Message}", "Unable to remove existing zip", isError: true);
                        Logger.Log($"ExportProject: unable to remove existing zip {zipPath}: {ex.Message}");
                        return false;
                    }
                }

                // include the base directory so the zip contains a top-level project folder (matching import expectations)
                ZipFile.CreateFromDirectory(projectFolder, zipPath, CompressionLevel.Optimal, includeBaseDirectory: true);

                Logger.Log($"Project exported to: {zipPath}");
                return true;
            }
            catch (Exception ex)
            {
                await Helpers.ShowMessage($"ERROR: ExportProject failed: {ex.Message}", "Export failed", isError: true);
                Logger.Log($"ExportProject failed: {ex.Message}");
                return false;
            }
        }
    }
}