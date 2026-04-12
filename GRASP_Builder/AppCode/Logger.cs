using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using System;
using System.IO;
using System.Threading;

namespace GRASP_Builder
{
    public class Logger
    {
        private static readonly object _fileLock = new object();
        private const int _maxAttempts = 8;
        private const int _retryDelayMs = 150;

        public static void Log(string message)
        {
            string DateTimeStamp = DateTime.Now.ToString("dd-MM-yyyy HH:mm:ss");
            Messenger.Default.Send<string>("WriteLogMessage", $"{DateTimeStamp} || {message}");
            AppendLineToTextFile($"log_{DateTime.Now:dd-MM-yyyy}.txt", $"{DateTimeStamp} || {message}");
        }

        public static void AppendLineToTextFile(string path, string line)
        {
            try
            {
                var directory = Path.GetDirectoryName(path);
                if (!string.IsNullOrEmpty(directory))
                    Directory.CreateDirectory(directory);

                lock (_fileLock)
                {
                    File.AppendAllText(path, line + Environment.NewLine);
                }
            }
            catch (Exception ex)
            {
                try
                {
                    File.AppendAllText("log_error_fallback.txt", $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} || Failed to append to {path}: {ex.Message}{Environment.NewLine}");
                }
                catch { }
            }
        }
    }
}