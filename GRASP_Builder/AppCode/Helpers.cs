using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder
{
    public class Helpers
    {
        public static string DictionaryToString(Dictionary<string, object> dict)
        {
            string text = string.Empty;
            foreach (KeyValuePair<string, object> kvp in dict)
                text += $" {kvp.Key}&{kvp.Value.ToString()} | ";

            return text.Substring(0, text.Length - 3);
        }

    }
}
