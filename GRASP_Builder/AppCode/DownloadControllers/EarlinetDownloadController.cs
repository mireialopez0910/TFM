using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GRASP_Builder.AppCode.DownloadControllers
{
    public class EarlinetDownloadController : IDownloadController
    {
        public EarlinetDownloadController(string repositoryDirectory, string workingDirectory)
        {
            _repositoryDirectory = repositoryDirectory;
            _workingDirectory = workingDirectory;
        }

        public string _repositoryDirectory { get; set; }
        public string _workingDirectory { get; set; }

        public async Task Download(DateTime FromDate, DateTime ToDate, string station)
        {
            try
            {
                string _station = station.ToLower().Split(" - ")[0];

                EarlinetService _earlinetClient = new EarlinetService();

                Directory.Delete(_workingDirectory, true);
                Directory.CreateDirectory(_workingDirectory);

                string date = DateTime.Now.ToString("dd_MM_yyyy__hh_mm");

                Logger.Log($"Downloading EARLINET-OPTICAL data");

                bool res_elda = await _earlinetClient.DownloadProductByDateRangeAsync("OPTICAL", FromDate.ToString("yyyy-MM-dd"), ToDate.ToString("yyyy-MM-dd"), _station, $"{_workingDirectory}EARLINET_ELDA_{date}.zip");
                if (res_elda)
                    Logger.Log($"Data downloaded correctly and saved in file {_workingDirectory}EARLINET_ELDA_{date}.zip");
                else
                    Logger.Log($"ELDA Data was not downloaded correctly");

                Messenger.Default.Send<string>("UpdateProgress", "15");
                
                Logger.Log($"Downloading EARLINET-ELPP data");

                bool res_elpp = await _earlinetClient.DownloadProductByDateRangeAsync("ELPP", FromDate.ToString("yyyy-MM-dd"), ToDate.ToString("yyyy-MM-dd"),_station, $"{_workingDirectory}EARLINET_ELPP_{date}.zip");
                if (res_elpp)
                    Logger.Log($"Data downloaded correctly and saved in file {_workingDirectory}EARLINET_ELPP_{date}.zip");
                else
                    Logger.Log($"ELPP Data was not downloaded correctly");

                unzipDownloadedFiles(date, station);
            }
            catch (Exception ex)
            {
                Logger.Log($"Exception: {ex.Message}");
            }
        }

        private void unzipDownloadedFiles(string date,string station)
        {

            Messenger.Default.Send<string>("UpdateProgress", "30");

            Logger.Log("Unzipping EARLINET files . . .");

            foreach (string file in FileHelpers.GetAllFiles(_workingDirectory))
            {
                if (file.Contains(date) && file.EndsWith(".zip"))
                {
                    //extract earlinet files
                    string folder = file.Replace(".zip", "");
                    UnzipFile(file, folder);

                    List<string> downloadedFolders = GetAllNestedFolders(folder);
                    string nestedFolder = downloadedFolders.FirstOrDefault();

                    List<string> folders = GetAllNestedFolders(nestedFolder);


                    foreach (string f in folders)
                    {
                        if (!f.EndsWith("elpp") && !f.EndsWith("opticalproducts") && !f.EndsWith("optical_products"))
                        {
                            string[] f_splitted = f.Split(System.IO.Path.DirectorySeparatorChar);

                            string dest_folder = System.IO.Path.Combine(_repositoryDirectory, station.Split(" - ")[0], f_splitted[^1]);

                            if (!Directory.Exists(dest_folder))
                                Directory.CreateDirectory(dest_folder);

                            foreach (var ncFile in Directory.GetFiles(f, "*.*", System.IO.SearchOption.AllDirectories))
                            {
                                string[] pathSplited = ncFile.Replace(@"\", @"/").Split(@"/");
                                string relative = pathSplited[pathSplited.Length - 1];
                                string destination = string.Empty;

                                if (!file.Contains("ELPP"))
                                    destination = System.IO.Path.Combine(dest_folder, relative.Split(".")[0] + "_elda.nc");
                                else
                                    destination = System.IO.Path.Combine(dest_folder, relative);

                                Directory.CreateDirectory(System.IO.Path.GetDirectoryName(destination));
                                File.Copy(ncFile, destination, overwrite: true);
                                if(AppConfig.Instance.IsDebugging())
                                Logger.Log($"File {ncFile} saved in folder: {destination}");
                            }

                        }
                    }

                }
            }

            Messenger.Default.Send<string>("UpdateProgress", "40");
        }
        private static void UnzipFile(string zipPath, string extractPath)
        {
            if (AppConfig.Instance.IsDebugging())
                Logger.Log($"Unziping file: {zipPath} to {extractPath}");

            try
            {
                if (File.Exists(zipPath))
                    ZipFile.ExtractToDirectory(zipPath, extractPath);
            }
            catch (InvalidDataException ex)
            {
                using (StreamWriter sw = new StreamWriter("log.txt", true))
                    Logger.Log("No files were downloaded for selected dates range");
            }
            catch (Exception ex)
            {
                using (StreamWriter sw = new StreamWriter("log.txt", true))
                    Logger.Log($"Exception: {ex.Message}");
            }
        }

        public static List<string> GetAllNestedFolders(string rootDir)
        {
            var result = new List<string>();
            if (Directory.Exists(rootDir))
            {
                foreach (var dir in Directory.GetDirectories(rootDir))
                {
                    result.Add(dir);

                    foreach (var subDir in Directory.GetDirectories(dir))
                    {
                        result.Add(subDir);
                    }
                }
            }

            return result;
        }

    }
}
