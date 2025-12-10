using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.Matlab
{
    public class SendFiles : IMatlabScript
    {
        public string Name { get; set; } = "SendFiles.m";
        private bool _preview = false;
        Dictionary<string, object> vars;
        public SendFiles(Dictionary<string, object> dic)
        {
            vars = dic;
        }


        public void PostExecutionActions(bool resultOK = true)
        {
            if (resultOK)
            {
                if (_preview)
                {
                    Dictionary<string, string> dic = MatlabController.ReadOutputFile("sendFiles_output.txt");

                    Messenger.Default.Send<Dictionary<string, string>>("UpdateUI", dic);
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

    }
}
