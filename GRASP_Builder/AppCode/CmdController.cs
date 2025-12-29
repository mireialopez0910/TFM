using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.AppCode
{
    public class CmdController
    {
        public static bool ExecuteGrasp(string outputDir, string config)
        {
            Logger.Log("Starting GRASP execution");
            Logger.Log(outputDir);
            Logger.Log(config);
                
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

                return Execute("run_grasp.sh");
            }
            else
            {
                Logger.Log("ERROR: specified GRASP installation directory does not exist");
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
                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();
                process.WaitForExit();

                Logger.Log("Output: " + output);
                if (!string.IsNullOrEmpty(error)) { Logger.Log("Error: " + error); return false; }
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

                Logger.Log($"Permissions granted: {output}");
                return true;
            }
        }
        public static bool Execute(string pathToScript)
        {
            var processInfo = new ProcessStartInfo
            {
                FileName = "/bin/bash",
                // CRITICAL: Added -c and wrapped path in quotes to handle spaces
                Arguments = $"-c \"./'{pathToScript}'\"",
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

                Logger.Log($"Permissions granted: {output}");
                return true;
            }
        }
    }
}
