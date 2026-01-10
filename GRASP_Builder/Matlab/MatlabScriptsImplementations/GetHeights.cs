using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.Matlab.MatlabScriptsImplementations
{
    public class GetHeights : IMatlabScript
    {
        #region Constructor

        public GetHeights(Dictionary<string, object> dic)
        {
            vars = dic;
        }
        #endregion

        public string Name {get;set;} = "GetHeights.m";

        public Dictionary<string, object> vars { get; set; }

        public virtual void PostExecutionActions(bool resultOK = true)
        {
            if (resultOK)
            {
                Dictionary<string, string> dic = MatlabController.ReadOutputFile("scripts_output.txt");

                Messenger.Default.Send<Dictionary<string, string>>("UpdateUI", dic);
            }
            Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
        }
    }
}
