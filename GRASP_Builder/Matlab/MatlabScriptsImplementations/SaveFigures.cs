using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.Matlab.MatlabScriptsImplementations
{
    public class SaveFigures : IMatlabScript
    {
        #region Constructor

        public SaveFigures(Dictionary<string, object> dic)
        {
            vars = dic;
        }
        
        #endregion
        
        #region Members

        #endregion

        #region Interface implementation

        public string Name { get; set; } = "SaveFigures.m";
        public Dictionary<string, object> vars { get; set; }

        public virtual void PostExecutionActions(bool resultOK = true)
        {
            Messenger.Default.Send<bool>("UpdateButtonsEnabled", true);
            Messenger.Default.Send<string>("ReloadFigureFiles", null);
        }
        #endregion
    }
}
