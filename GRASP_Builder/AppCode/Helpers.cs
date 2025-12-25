using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Threading;
using GRASP_Builder.Views;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.IO;
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

        public static async Task<bool> ShowMessage(string message, string title, bool isError = false, bool isWarning = false)
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;
            var dialog = new MessageWindow(message, title, isError, isWarning);
            return await dialog.ShowDialog<bool>(owner);
        }
    }

    public class FileHelpers
    {
        public static void RenameFile(string sourcePath, string newName) //classe nova file helper?? mirar quant codi es repeteix etc -> nadal?
        {
            // Obtener el directorio del fichero original
            string directory = Path.GetDirectoryName(sourcePath);

            // Construir la nueva ruta con el nombre nuevo
            string newPath = Path.Combine(directory, newName);

            // Mover el fichero (esto efectivamente lo renombra)
            File.Move(sourcePath, newPath);
        }

        public static void CopyAndRenameFile(string sourcePath, string newName) //classe nova file helper?? mirar quant codi es repeteix etc -> nadal?
        {
            // Obtener el directorio del fichero original
            string directory = Path.GetDirectoryName(sourcePath);

            // Construir la nueva ruta con el nombre nuevo
            string newPath = Path.Combine(directory, newName);

            // Mover el fichero (esto efectivamente lo renombra)
            File.Copy(sourcePath, newPath, true);
        }

        public static void CopyAndRenameFile_newPath(string sourcePath, string outputPath, string newName) //classe nova file helper?? mirar quant codi es repeteix etc -> nadal?
        {
            if (!Directory.Exists(outputPath))
                Directory.CreateDirectory(outputPath);

            File.Copy(sourcePath, Path.Combine(outputPath, newName), true);
        }

    }
}
