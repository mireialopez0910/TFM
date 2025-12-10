using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tmds.DBus.Protocol;

namespace GRASP_Builder
{
    public class Logger
    {
        public static void Log(string message)
        {
            Messenger.Default.Send<string>("WriteLogMessage", $"{DateTime.Now} || {message}");
            //write file?
        }
    }
}
