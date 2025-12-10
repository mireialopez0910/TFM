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
                case ScriptType.Preview:
                case ScriptType.SendFiles:
                    if (dic.Count>0)
                        return new SendFiles(dic);
                    else throw new NotSupportedException($"File type {type.ToString()} is not supported");
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
        Preview,
        SendFiles
    }
}
