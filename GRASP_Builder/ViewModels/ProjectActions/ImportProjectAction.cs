using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using GRASP_Builder.Views;
using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Threading.Tasks;
using Tmds.DBus.Protocol;
using static System.Collections.Specialized.BitVector32;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public class ImportProjectAction : IProjectAction
    {
        public string Title { get; set; } = "Import project from zip file";
        public string DirectoryPath { get; set; }    // will hold the selected .zip file path
        public string ProjectName { get; set; }
        public bool IsProjectNameVisible { get; set; } = false;
        public bool IsDirectoryPathVisible { get; set; } = true;
        
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

        public async Task<bool> Execute()
        {
            if (string.IsNullOrWhiteSpace(DirectoryPath) || !File.Exists(DirectoryPath))
            {
                Logger.Log($"ImportProject: zip file not found: {DirectoryPath}");
                return false;
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
                string finalName = Path.GetFileName(extractedProjectRoot.TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar));

                DirectoryPath = Path.Combine(parentDir, finalName); // update to point to the imported project folder

                if (Directory.Exists(DirectoryPath))
                {
                    bool result = await Helpers.ShowMessage($"ERROR: target folder already exists: {DirectoryPath}. Folder will be overwritten, do you want to continue?", "Folder already exists", isWarning: true);
                    Logger.Log($"ImportProject: target folder already exists: {DirectoryPath}");
                    if (!result)
                    {
                        Messenger.Default.Send<bool>("CloseProjectActionWindow", false);
                        return false;
                    }
                }

                // Move extracted content to DirectoryPath. Prefer Directory.Move, fallback to copy if moving fails (cross-drive)
                try
                {
                    Directory.Move(extractedProjectRoot, DirectoryPath);
                }
                catch
                {
                    // fallback to copy
                    CopyDirectory(extractedProjectRoot, DirectoryPath);
                }

                Logger.Log($"Project imported to: {DirectoryPath}");
                Messenger.Default.Send<bool>("CloseProjectActionWindow", true);
                return true;
            }
            catch (InvalidDataException)
            {
                await Helpers.ShowMessage("ImportProject: invalid or corrupted zip file.", "ImportProject failed", isError: true);
                Logger.Log("ImportProject: invalid or corrupted zip file.");
                Messenger.Default.Send<bool>("CloseProjectActionWindow", false);
                return false;
            }
            catch (Exception ex)
            {
                await Helpers.ShowMessage($"ERROR: ImportProject failed: {ex.Message}", "ImportProject failed", isError: true);
                Logger.Log($"ImportProject failed: {ex.Message}");
                Messenger.Default.Send<bool>("CloseProjectActionWindow", false);
                return false;
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
