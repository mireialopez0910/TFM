using Avalonia.Controls.ApplicationLifetimes;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GRASP_Builder.AppCode
{
    public class CmdController
    {
        public static bool ExecuteGrasp(string outputDir, string config)
        {
            Logger.Log($"Starting GRASP execution for configuration {config}");
            Logger.Log($"Results will be saved in {outputDir}");
                            
            string graspExePath = AppConfig.Instance.GetValue("GraspInstallPath");
           
            if (Directory.Exists(graspExePath)) 
            {
                string text = $"#!/bin/bash{Environment.NewLine}cd {outputDir}{Environment.NewLine}{graspExePath}grasp UPC_{config}.yml";

                string pathToScript = Path.Combine(Directory.GetCurrentDirectory(), "run_grasp.sh");
                if (File.Exists(pathToScript))
                    File.Delete(pathToScript);
                File.Create(pathToScript).Close();
                File.WriteAllText(pathToScript, text);

                GiveExecutionPermisions(pathToScript);
                
                bool result = Execute("run_grasp.sh");

                return result;
            }
            else
            {
                MessagesController.Show($"Specified GRASP installation directory does not exist", $"ERROR", isError: true);
                Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
                return false;
            }
        }

        public static bool ExecuteCommand(string pathToScript)
        {
            var processInfo = new ProcessStartInfo
            {
                FileName = "/bin/bash",
                Arguments = pathToScript,
                RedirectStandardOutput = true,
                UseShellExecute = false
            };

            using (var process = Process.Start(processInfo))
            {
                Messenger.Default.Send<string>("WriteMatlabOutput_DC", $"Starting {Path.GetFileName(pathToScript)} execution, please wait");
                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();
                process.WaitForExit();

                Messenger.Default.Send<string>("WriteMatlabOutput_DC", output);

                if (!string.IsNullOrEmpty(error))
                {
                    //Logger.Log("Error: " + error);
                    Messenger.Default.Send<string>("WriteMatlabOutput_DC", "ERROR: " + error);
                    MessagesController.Show($"Error during {Path.GetFileName(pathToScript)} execution" + error,$"Error during {Path.GetFileName(pathToScript)} execution", isError: true); 
                    return false;
                }
                Messenger.Default.Send<string>("WriteMatlabOutput_DC", "Execution ended successfully");
                return true;
            }
        }

        public static bool GiveExecutionPermisions(string pathToScript)
        {
            var processInfo = new ProcessStartInfo
            {
                FileName = "/bin/bash",
                // CRITICAL: Added -c and wrapped path in quotes to handle spaces
                Arguments = $"-c \"chmod +x '{pathToScript}'\"",
                RedirectStandardOutput = true,
                RedirectStandardError = true, // Added this to catch errors
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using (var process = Process.Start(processInfo))
            {
                // 1. Read the streams (this is synchronous)
                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();

                // 2. Explicitly wait for the OS to close the process
                process.WaitForExit();

                // 3. Check the ExitCode (0 usually means success in Linux)
                if (process.ExitCode != 0 || !string.IsNullOrEmpty(error))
                {
                    Logger.Log($"Error giving permissions to {pathToScript}: {error}");
                    return false;
                }

                //Logger.Log($"Permissions granted: {output}");
                return true;
            }
        }
        public static bool Execute(string pathToScript)
        {
            try
            {
                var processInfo = new ProcessStartInfo
                {
                    FileName = "/bin/bash",
                    Arguments = $"-c \"./'{pathToScript}'\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                using (var process = new Process())
                {
                    process.StartInfo = processInfo;

                    // Subscribe to async events
                    var output = new StringBuilder();
                    process.OutputDataReceived += (s, e) => { if (!string.IsNullOrEmpty(e.Data)) output.AppendLine(e.Data); };

                    var errors = new StringBuilder();
                    process.ErrorDataReceived += (s, e) => { if (!string.IsNullOrEmpty(e.Data)) errors.AppendLine(e.Data); };
                    Messenger.Default.Send("WriteMatlabOutput_DC", $"Starting execution of {Path.GetFileName(pathToScript)}. . .");
                    process.Start();

                    // Start asynchronous read
                    process.BeginOutputReadLine();
                    process.BeginErrorReadLine();

                    // Wait for process to exit
                    process.WaitForExit();
                    Messenger.Default.Send("WriteMatlabOutput_DC", output.ToString());
                    if (process.ExitCode != 0)
                    {
                        MessagesController.Show(
                            $"ERROR: Error executing {pathToScript}: {errors.ToString()}",
                            "ERROR",
                            isError: true
                        );
                        Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
                        return false;
                    }

                    MessagesController.Show($"Execution of {Path.GetFileName(pathToScript)} finished. Check output in order to confirm execution results.","Execution finished",isError: false);
                    Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
                    Logger.Log($"Execution of {pathToScript} finished");
                    return true;
                }

            }
            catch (Exception ex)
            {
                MessagesController.Show($"ERROR: {ex.Message}", "ERROR", isError: true);
                Messenger.Default.Send<string>("WriteMatlabOutput_DC", "ERROR"+ex.Message);
                Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
                return false;
            }
        }
    }
}
