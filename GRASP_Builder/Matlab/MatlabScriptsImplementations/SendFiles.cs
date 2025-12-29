using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using Avalonia.Platform.Storage;
using GRASP_Builder.AppCode;

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

                Dictionary<string, string> dic = MatlabController.ReadOutputFile("sendFiles_output.txt");

                Messenger.Default.Send<Dictionary<string, string>>("UpdateUI", dic);

                // corrected TryGetValue usage and call to save output name into config file
                if (dic.TryGetValue("GARRLiC_file_name", out string outputName))
                {
                    if (dic.TryGetValue("selected_config", out string selected_config)) 
                    {
                        if (dic.TryGetValue("output_dir", out string output_dir))
                        {
                            SaveOutputNameInConfigFile(outputName, selected_config, output_dir);
                            CmdController.ExecuteGrasp(output_dir, selected_config);
                        }
                        else
                            Logger.Log("ERROR; No output_dir in list of dicctionaries for send files, can not create configuration file .yml");
                    }
                }

            }
            Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
        }

        public void PreExecutionActions()
        {
            MatlabController.CleanMatlabFiles("config_preview.txt", "sendFiles_output.txt");

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

        private void SaveOutputNameInConfigFile(string outputName, string config, string output_dir)
        {
            //TO DO: ha de contenir la configuracio del GARRLiC en el nom
            try
            {
                string aux_configfilepath = Path.Combine(Directory.GetCurrentDirectory(),"Matlab","Scripts", $"UPC_{config}.yml");
                                
                FileHelpers.CopyAndRenameFile_newPath(aux_configfilepath, output_dir, $"UPC_{config}.yml");

                string configfilepath = Path.Combine(output_dir, $"UPC_{config}.yml");

                string text = File.ReadAllText(configfilepath);

                if (text.Contains("OutputName_Value"))
                {
                    text = text.Replace("OutputName_Value", outputName);
                    File.WriteAllText(configfilepath, text);
                    Logger.Log($"SaveOutputNameInConfigFile: replaced token with '{outputName}' in {configfilepath}");
                }
                else
                {
                    // If token not present, append an explicit key so the config contains the output name.
                    Logger.Log($"ERROR in SaveOutputNameInConfigFile: OutputName_Value token was not found in {configfilepath}");
                }

                string figuresDir = Path.Combine(output_dir, "figures");
                if(!Directory.Exists(figuresDir))
                    Directory.CreateDirectory(figuresDir);
                
            }
            catch (Exception ex)
            {
                Logger.Log($"ERROR SaveOutputNameInConfigFile failed: {ex.Message}");
            }
        }

        #endregion
    }
}
