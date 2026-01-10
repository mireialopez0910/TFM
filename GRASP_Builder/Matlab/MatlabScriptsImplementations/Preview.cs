using GRASP_Builder.AppCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.Matlab.MatlabScriptsImplementations
{
    public class Preview : IMatlabScript
    {
        #region Constructor

        public Preview(Dictionary<string, object> dic)
        {
            vars = dic;
        }
        #endregion

        #region Members

        public Dictionary<string, object> vars { get; set; }

        #endregion

        #region Interface implementation
        public string Name { get; set; } = "Preview.m";

        public virtual void PostExecutionActions(bool resultOK = true)
        {
            if (resultOK)
            {
                Dictionary<string, string> dic = MatlabController.ReadOutputFile("scripts_output.txt");

                Messenger.Default.Send<Dictionary<string, string>>("UpdateUI", dic);
            }
            Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
        }

        #endregion
    }
}