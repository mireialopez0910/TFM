using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public class ImportProjectAction : IProjectAction
    {
        public string Title { get; set; } = "Import project from zip file";
        public string DirectoryPath { get; set; }    // will hold the selected .zip file path
        public string ProjectName { get; set; }
        public bool IsProjectNameVisible { get; set; } = false;

        public async Task Browse()
        {
            // Show file picker for zip files
            var window = (App.Current.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime)?.MainWindow;
            var dialog = new OpenFileDialog
            {
                Title = "Select project zip file",
                AllowMultiple = false,
                Filters = new System.Collections.Generic.List<FileDialogFilter>
                {
                    new FileDialogFilter { Name = "Zip files", Extensions = { "zip" } },
                    new FileDialogFilter { Name = "All files", Extensions = { "*" } }
                }
            };

            string[]? result;
            try
            {
                result = await dialog.ShowAsync(window);
            }
            catch
            {
                result = null;
            }

            if (result != null && result.Length > 0)
            {
                DirectoryPath = result[0];
                // set a sensible default project name from zip filename (without extension)
                ProjectName = Path.GetFileNameWithoutExtension(DirectoryPath);
            }
        }

        public void Execute()
        {
            if (string.IsNullOrWhiteSpace(DirectoryPath) || !File.Exists(DirectoryPath))
            {
                Logger.Log($"ImportProject: zip file not found: {DirectoryPath}");
                return;
            }

            string zipPath = DirectoryPath;
            string parentDir = Path.GetDirectoryName(zipPath) ?? Directory.GetCurrentDirectory();
            string tempExtract = Path.Combine(Path.GetTempPath(), "grasp_import_" + Guid.NewGuid().ToString("N"));

            try
            {
                Directory.CreateDirectory(tempExtract);
                // extract into a temp folder first
                ZipFile.ExtractToDirectory(zipPath, tempExtract);

                // Try to detect a single top-level folder inside the zip (common layout: TopFolder/...)
                var topLevelDirs = Directory.GetDirectories(tempExtract);
                string extractedProjectRoot;
                if (topLevelDirs.Length == 1)
                {
                    extractedProjectRoot = topLevelDirs[0];
                }
                else
                {
                    // multiple top-level entries or flat zip -> treat the temp folder itself as the project root
                    extractedProjectRoot = tempExtract;
                }

                // Determine final destination folder
                string finalName = !string.IsNullOrWhiteSpace(ProjectName)
                    ? ProjectName
                    : Path.GetFileName(extractedProjectRoot.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));

                string targetDir = Path.Combine(parentDir, finalName);

                if (Directory.Exists(targetDir))
                {
                    Logger.Log($"ImportProject: target folder already exists: {targetDir}");
                    return;
                }

                // Move extracted content to targetDir. Prefer Directory.Move, fallback to copy if moving fails (cross-drive)
                try
                {
                    Directory.Move(extractedProjectRoot, targetDir);
                }
                catch
                {
                    // fallback to copy
                    CopyDirectory(extractedProjectRoot, targetDir);
                }

                Logger.Log($"Project imported to: {targetDir}");
            }
            catch (InvalidDataException)
            {
                Logger.Log("ImportProject: invalid or corrupted zip file.");
            }
            catch (Exception ex)
            {
                Logger.Log($"ImportProject failed: {ex.Message}");
            }
            finally
            {
                // cleanup temporary extraction folder if it still exists
                try
                {
                    if (Directory.Exists(tempExtract))
                        Directory.Delete(tempExtract, true);
                }
                catch { /* ignore cleanup errors */ }
            }
        }

        private static void CopyDirectory(string sourceDir, string destDir)
        {
            var dirStack = new System.Collections.Generic.Stack<(string src, string dst)>();
            dirStack.Push((sourceDir, destDir));
            while (dirStack.Count > 0)
            {
                var (src, dst) = dirStack.Pop();
                Directory.CreateDirectory(dst);

                foreach (var file in Directory.GetFiles(src))
                {
                    var destFile = Path.Combine(dst, Path.GetFileName(file));
                    File.Copy(file, destFile, overwrite: true);
                }

                foreach (var sub in Directory.GetDirectories(src))
                {
                    var subDst = Path.Combine(dst, Path.GetFileName(sub));
                    dirStack.Push((sub, subDst));
                }
            }
        }
    }
}
