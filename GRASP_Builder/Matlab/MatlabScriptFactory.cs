using GRASP_Builder.Matlab.MatlabScriptsImplementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tmds.DBus.Protocol;

namespace GRASP_Builder.Matlab
{
    public class MatlabScriptFactory
    {
        public static IMatlabScript Create(ScriptType type, Dictionary<string, object> dic)
        {
            switch (type)
            {
                case ScriptType.GetHeights:
                    return new GetHeights(dic);
                case ScriptType.Preview:
                    return new Preview(dic);
                case ScriptType.SendFiles:
                        return new SendFiles(dic);
                case ScriptType.PlotFigure:
                    return new PlotFigure(dic);
                case ScriptType.SaveFigures:
                    return new SaveFigures(dic);
                default:
                    throw new NotSupportedException($"File type {type.ToString()} is not supported");
            }
        }
    }

    
}

namespace GRASP_Builder
{
    public enum ScriptType
    {
        GetHeights,
        Preview,
        SendFiles,
        PlotFigure,
        SaveFigures
    }
}
