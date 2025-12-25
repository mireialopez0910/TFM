using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace GRASP_Builder.Matlab
{
    public interface IMatlabScript
    {
        public string Name { get; }
        public Dictionary<string, object> vars { get; set; }
        public void PreExecutionActions();
        public void PostExecutionActions(bool resultOK = true);
    }
}