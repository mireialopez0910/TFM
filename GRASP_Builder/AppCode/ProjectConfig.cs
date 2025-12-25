using System;
using System.Collections.Generic;
using System.IO;

namespace GRASP_Builder.AppCode
{
    /// <summary>
    /// Simple key=value project configuration helper that reads/writes a plain text
    /// "project.grasp" file located in the given directory.
    /// </summary>
    public class ProjectConfig
    {
        private readonly string _directoryPath;
        private readonly string _filePath;
        private readonly Dictionary<string, string> _data = new();
        private readonly object _sync = new();

        public ProjectConfig(string directoryPath)
        {
            if (string.IsNullOrWhiteSpace(directoryPath))
                throw new ArgumentException("directoryPath must be provided", nameof(directoryPath));

            _directoryPath = directoryPath;
            if (!Directory.Exists(_directoryPath))
                Directory.CreateDirectory(_directoryPath);

            _filePath = Path.Combine(_directoryPath, "project.grasp");
            Load();
        }

        private void Load()
        {
            lock (_sync)
            {
                _data.Clear();
                if (!File.Exists(_filePath))
                    return;

                foreach (var line in File.ReadAllLines(_filePath))
                {
                    if (string.IsNullOrWhiteSpace(line))
                        continue;

                    var trimmed = line.Trim();
                    if (trimmed.StartsWith("#"))
                        continue;

                    var idx = trimmed.IndexOf('=');
                    if (idx <= 0)
                        continue;

                    var key = trimmed.Substring(0, idx).Trim();
                    var value = trimmed.Substring(idx + 1).Trim();
                    _data[key] = value;
                }
            }
        }

        public bool Save()
        {
            try
            {
                lock (_sync)
                {
                    using var sw = new StreamWriter(_filePath, false, System.Text.Encoding.UTF8);
                    foreach (var kvp in _data)
                        sw.WriteLine($"{kvp.Key}={kvp.Value}");
                }
                return true;
            }
            catch (Exception ex)
            {
                Logger.Log($"ProjectConfig.Save failed: {ex.Message}");
                return false;
            }
        }

        public string? GetValue(string key)
        {
            if (key == null) return null;
            lock (_sync)
            {
                return _data.TryGetValue(key, out var v) ? v : null;
            }
        }

        public void SetValue(string key, string value)
        {
            if (key == null) throw new ArgumentNullException(nameof(key));
            lock (_sync)
            {
                _data[key] = value ?? string.Empty;
            }
        }

        public bool Remove(string key)
        {
            if (key == null) return false;
            lock (_sync)
            {
                return _data.Remove(key);
            }
        }

        public IReadOnlyDictionary<string, string> AsReadOnlyDictionary()
        {
            lock (_sync)
            {
                return new Dictionary<string, string>(_data);
            }
        }

        /// <summary>
        /// Reloads the file from disk discarding in-memory changes.
        /// </summary>
        public void Reload()
        {
            Load();
        }

        public string DirectoryPath => _directoryPath;
        public string FilePath => _filePath;
    }
}