using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.Matlab.MatlabScriptsImplementations
{
    public class PlotFigure : IMatlabScript
    {
        #region Constructor

        public PlotFigure(Dictionary<string, object> dic)
        {
            vars = dic;
        }

        #endregion

        #region Interface implementation

        public string Name { get; set; } = "PlotFigure.m";
        public Dictionary<string, object> vars { get; set; }

        #endregion
    }
}
