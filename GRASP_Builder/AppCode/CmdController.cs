using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.AppCode
{
    public class CmdController
    {
        public static bool ExecuteGrasp(string config)
        {
            Logger.Log("Startimg GRASP execution");
            string graspExePath = AppConfig.Instance.GetValue("GraspInstallPath");
            if (Directory.Exists(graspExePath))
                return ExecuteCommand(new List<string> { $"cd {Directory.GetCurrentDirectory()}",
                    $"{graspExePath}grasp UPC_{config}.yml"});
            else
            {
                Logger.Log("ERROR: specified GRASP installation directory does not exist");
                return false;
            }
        }

        public static bool ExecuteCommand(List<string> commands)
        {
            bool isError = false;

            bool isWindows = RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
            string shell = isWindows ? "cmd.exe" : "/bin/bash";
            string argPrefix = isWindows ? "/c" : "-c";

            foreach (var cmd in commands)
            {
                Console.WriteLine($"Executing: {cmd}");

                var psi = new ProcessStartInfo
                {
                    FileName = shell,
                    // We wrap the command in quotes to handle spaces or special characters
                    Arguments = $"{argPrefix} \"{cmd}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                using var process = Process.Start(psi);

                // Read output and errors
                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();

                process.WaitForExit();

                if (!string.IsNullOrEmpty(output))
                {
                    //Console.WriteLine(output);
                    //Write in output view in DC?
                }
                if (!string.IsNullOrEmpty(error))
                {
                    //Console.Error.WriteLine($"Error: {error}");
                    //Write in output and error view in DC?
                    Logger.Log($"ERROR: {error}");
                    isError = true;
                }
            }
            return !isError;
        }
    }
}
