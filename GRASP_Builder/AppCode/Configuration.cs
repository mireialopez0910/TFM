using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;

namespace GRASP_Builder
{
    public class AppConfig
    {
        private static readonly Lazy<AppConfig> _instance =
             new(() => new AppConfig("config.json"));

        public static AppConfig Instance => _instance.Value;

        private readonly string _configFilePath;
        private Dictionary<string, object> _configData;

        // Private constructor to prevent external creation
        private AppConfig(string filePath)
        {
            _configFilePath = filePath;
            _configData = LoadConfig();
        }
        private Dictionary<string, object> LoadConfig()
        {
            if (!File.Exists(_configFilePath))
            {
                // Create empty config if file doesn't exist
                var emptyConfig = new Dictionary<string, object>();
                SaveConfig(emptyConfig);
                return emptyConfig;
            }

            string json = File.ReadAllText(_configFilePath);
            return JsonSerializer.Deserialize<Dictionary<string, object>>(json)
                   ?? new Dictionary<string, object>();
        }

        private void SaveConfig(Dictionary<string, object> data)
        {
            string json = JsonSerializer.Serialize(data, new JsonSerializerOptions { WriteIndented = true });
            File.WriteAllText(_configFilePath, json);
        }

        public string? GetValue(string key)
        {
            string result = _configData.TryGetValue(key, out var value) ? value.ToString() : null;

            if (key=="WorkingDirectory")
            {
                if (!System.IO.Directory.Exists(result))
                    System.IO.Directory.CreateDirectory(result);
            }

            return result;
        }

        public void SetValue(string key, object value)
        {
            if(!_configData.ContainsKey(key))
            _configData.Add(key, value);
            else
                _configData[key] = value;
            SaveConfig(_configData);
        }

        public bool IsDebugging()
        {
            return true;
        }
    }
}
