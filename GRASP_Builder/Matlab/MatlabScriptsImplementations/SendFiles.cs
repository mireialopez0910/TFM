using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace GRASP_Builder.Matlab
{
    public class SendFiles : IMatlabScript
    {
        #region Construction

        public SendFiles(Dictionary<string, object> dic)
        {
            vars = dic;
        }

        #endregion
       
        #region Members

        private bool _preview = false;
        
        #endregion

        #region Interface implementation

        public string Name { get; set; } = "SendFiles.m";

        public Dictionary<string, object> vars { get; set; }

        public void PostExecutionActions(bool resultOK = true)
        {
            if (resultOK)
            {
                if (_preview)
                {
                    Dictionary<string, string> dic = MatlabController.ReadOutputFile("sendFiles_output.txt");

                    Messenger.Default.Send<Dictionary<string, string>>("UpdateUI", dic);
                    
                    // corrected TryGetValue usage and call to save output name into config file
                    if (dic.TryGetValue("GARRLiC_file_name", out string outputName))
                    {
                        if (dic.TryGetValue("selected_config", out string selected_config))
                            SaveOutputNameInConfigFile(outputName, selected_config);
                    }
                }
            }
            Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
        }

        public void PreExecutionActions()
        {
            Messenger.Default.Send<bool>("UpdateButtonsEnabled", false);

            MatlabController.WriteInputFile("config_preview.txt", vars);

            if (vars.TryGetValue("preview", out object preview))
            {
                if (preview == "true")
                    _preview = true;
                else _preview = false;
            }
            else
                _preview = false;
        }

        private void SaveOutputNameInConfigFile(string outputName, string config)
        {
            //TO DO: ha de contenir la configuracio del GARRLiC en el nom
            try
            {
                string configfilepath = $@"{AppConfig.Instance.GetValue("ProjectDirectoryPath")}/Matlab/Scripts/datacrossing";

                Helpers.RenameFile(configfilepath, $"UPC_{config}.yml");
                string configPath = Path.Combine(Directory.GetCurrentDirectory(), "config.txt");
                string text = File.ReadAllText(configPath);

                if (text.Contains("OutputName_Value"))
                {
                    text = text.Replace("outputdilenamevalue", outputName);
                    File.WriteAllText(configPath, text);
                    Logger.Log($"SaveOutputNameInConfigFile: replaced token with '{outputName}' in {configPath}");
                }
                else
                {
                    // If token not present, append an explicit key so the config contains the output name.
                    var appendLine = Environment.NewLine + $"GARRLiC_file_name={outputName}";
                    File.AppendAllText(configPath, appendLine);
                    Logger.Log($"SaveOutputNameInConfigFile: token not found, appended GARRLiC_file_name={outputName} to {configPath}");
                }
            }
            catch (Exception ex)
            {
                Logger.Log($"SaveOutputNameInConfigFile failed: {ex.Message}");
            }
        }

        #endregion
    }
}
