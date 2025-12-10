using GRASP_Builder.Matlab;
using System;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace GRASP_Builder
{
    public class MatlabController
    {

        public static void RunMatlabScript(ScriptType type, Dictionary<string, object> list = null)
        {
            IMatlabScript script = MatlabScriptFactory.Create(type, list);

            string scriptPath = $@"{Directory.GetCurrentDirectory()}/Matlab/Scripts/datacrossing/{script.Name}";

            Thread t = new Thread(() =>
            {
                try
                {
                    ProcessStartInfo startInfo = new ProcessStartInfo
                    {
                        FileName = "matlab", // Ensure 'matlab' is in your system PATH
                        Arguments = $"-batch \"run('{scriptPath}')\"",
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                        CreateNoWindow = true
                    };

                    Logger.Log($"Executing pre execution actions of script {script.Name}");

                    script.PreExecutionActions();

                    using var process = new Process { StartInfo = startInfo };

                    process.OutputDataReceived += (s, e) =>
                    {
                        if (e.Data != null)
                            Messenger.Default.Send<string>("WriteMatlabOutput", e.Data);
                    };

                    process.ErrorDataReceived += (s, e) =>
                    {
                        if (e.Data != null)
                            Messenger.Default.Send<string>("WriteMatlabErrors", e.Data);
                    };

                    Messenger.Default.Send<string>("WriteMatlabOutput", $"Executing MATLAB Script {script.Name} . . .");

                    process.Start();

                    process.BeginOutputReadLine();
                    process.BeginErrorReadLine();

                    process.WaitForExit();

                    if (process.ExitCode == 0) //OK
                    {
                        Logger.Log($"Script was executed correctly, executing post execution actions . . .");
                        script.PostExecutionActions();
                    }
                    else
                    {
                        Logger.Log($"Error occured during execution, executing post execution actions . . .");
                        script.PostExecutionActions(false);
                        Messenger.Default.Send<string>("WriteMatlabOutput", $"MATLAB process exited with code {process.ExitCode}. Check error tab in order to know further information.");
                    }
                }
                catch (Exception ex)
                {
                    Logger.Log($"Exception occurred while running MATLAB script: {ex.Message}");
                    Messenger.Default.Send<string>("WriteMatlabErrors", "Exception occurred while running MATLAB script: " + ex.Message);
                    Messenger.Default.Send<string>("WriteMatlabOutput", $"Exception occured. Check error tab in order to know further information.");
                }
            });
            t.Start();
        }

        public static Dictionary<string, string> ReadOutputFile(string ouputFileName)
        {
            string filePath = @$"{Directory.GetCurrentDirectory()}/Matlab/Scripts/datacrossing/{ouputFileName}";

            var dict = new Dictionary<string, string>();

            foreach (var line in File.ReadAllLines(filePath))
            {
                // Ignore blank lines and comments
                if (string.IsNullOrWhiteSpace(line) || line.TrimStart().StartsWith("#"))
                    continue;

                // Split using '='
                var parts = line.Split('=');

                if (parts.Length == 2)
                {
                    string key = parts[0].Trim();
                    string value = parts[1].Trim();
                    dict[key] = value;
                }
            }

            return dict;
        }

        public static void WriteInputFile(string fileName, Dictionary<string, object> vars)
        {
            string configname = @$"{Directory.GetCurrentDirectory()}/Matlab/Scripts/datacrossing/{fileName}";
            File.Delete(configname);
            foreach (KeyValuePair<string, object> pair in vars)
            {
                MatlabController.SaveValueInConfiguration(pair.Key, pair.Value.ToString(), "config_preview.txt");
            }
        }

        public static void SaveValueInConfiguration(string key, string value, string configFileName)
        {
            string configname = @$"{Directory.GetCurrentDirectory()}/Matlab/Scripts/datacrossing/{configFileName}";
            if (File.Exists(configname))
            {
                string text = System.IO.File.ReadAllText(configname);
                if (text.Length > 0)
                {
                    using (StreamWriter sw = File.AppendText(configname))
                    {
                        sw.WriteLine($"{key}={value}");
                    }
                }
                else
                {
                    File.Delete(configname);
                    using (StreamWriter sw = File.CreateText(configname))
                    {
                        sw.WriteLine($"{key}={value}");
                    }
                }
            }
            else
            {
                using (StreamWriter sw = File.CreateText(configname))
                {
                    sw.WriteLine($"{key}={value}");
                }
            }
        }

        bool IsMatlabRunning()
        {
            return Process.GetProcessesByName("MATLAB").Length > 0;
        }
    }
}
