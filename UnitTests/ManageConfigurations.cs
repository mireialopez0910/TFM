using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text.Json;
using Xunit;
using GRASP_Builder.AppCode;
using GRASP_Builder;

namespace UnitTests
{
    public class ManageConfigurations
    {
        [Fact]
        public void ModifyAppConfig()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), "GRASP_AppConfig_Test_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);
            string tempConfig = Path.Combine(tempDir, "test_config.json");

            // Create AppConfig instance using the private constructor via reflection
            var ctor = typeof(AppConfig).GetConstructor(BindingFlags.Instance | BindingFlags.NonPublic, null, new Type[] { typeof(string) }, null);
            Assert.NotNull(ctor);
            var appConfig = (AppConfig)ctor.Invoke(new object[] { tempConfig });

            // Modify and verify
            appConfig.SetValue("UnitTest_Key", "UnitTest_Value");
            var value = appConfig.GetValue("UnitTest_Key");
            Assert.Equal("UnitTest_Value", value);

            // cleanup
            try { if (File.Exists(tempConfig)) File.Delete(tempConfig); } catch { }
            try { if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true); } catch { }
        }

        [Fact]
        public void LoadAppConfig()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), "GRASP_AppConfig_LoadTest_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);
            string tempConfig = Path.Combine(tempDir, "load_config.json");

            // prepare json file
            var payload = new Dictionary<string, object>
            {
                ["PreKey"] = "PreValue",
                ["WorkingDirectory"] = "./Data/"
            };
            File.WriteAllText(tempConfig, JsonSerializer.Serialize(payload, new JsonSerializerOptions { WriteIndented = true }));

            // create instance that will read the file on construction
            var ctor = typeof(AppConfig).GetConstructor(BindingFlags.Instance | BindingFlags.NonPublic, null, new Type[] { typeof(string) }, null);
            Assert.NotNull(ctor);
            var appConfig = (AppConfig)ctor.Invoke(new object[] { tempConfig });

            var loaded = appConfig.GetValue("PreKey");
            Assert.Equal("PreValue", loaded);

            // cleanup
            try { if (File.Exists(tempConfig)) File.Delete(tempConfig); } catch { }
            try { if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true); } catch { }
        }

        [Fact]
        public void SaveAppConfig()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), "GRASP_AppConfig_SaveTest_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);
            string tempConfig = Path.Combine(tempDir, "save_config.json");

            var ctor = typeof(AppConfig).GetConstructor(BindingFlags.Instance | BindingFlags.NonPublic, null, new Type[] { typeof(string) }, null);
            Assert.NotNull(ctor);
            var appConfig = (AppConfig)ctor.Invoke(new object[] { tempConfig });

            appConfig.SetValue("SaveKey", "SaveValue");

            // file should have been written by SetValue
            Assert.True(File.Exists(tempConfig), "Config file should exist after SetValue/Save.");

            var json = File.ReadAllText(tempConfig);
            Assert.Contains("\"SaveKey\"", json);
            Assert.Contains("SaveValue", json);

            // cleanup
            try { if (File.Exists(tempConfig)) File.Delete(tempConfig); } catch { }
            try { if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true); } catch { }
        }

        [Fact]
        public void ModifyProjectConfig()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), "GRASP_ProjectConfig_Modify_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);

            var pc = new ProjectConfig(tempDir);
            pc.SetValue("projKey", "projValue");
            bool saved = pc.Save();
            Assert.True(saved, "ProjectConfig.Save should return true.");

            // reload and verify
            pc.Reload();
            var v = pc.GetValue("projKey");
            Assert.Equal("projValue", v);

            // cleanup
            try { if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true); } catch { }
        }

        [Fact]
        public void LoadProjectConfig()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), "GRASP_ProjectConfig_Load_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);
            string cfgPath = Path.Combine(tempDir, "project.grasp");

            File.WriteAllLines(cfgPath, new[]
            {
                "# comment line",
                "alpha=one",
                " beta = two ",
                "ignoredline",
                "keyWithEquals=value=with=equals"
            });

            var pc = new ProjectConfig(tempDir);
            Assert.Equal("one", pc.GetValue("alpha"));
            Assert.Equal("two", pc.GetValue("beta"));
            Assert.Equal("value=with=equals", pc.GetValue("keyWithEquals"));

            // cleanup
            try { if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true); } catch { }
        }

        [Fact]
        public void SaveProjectConfig()
        {
            string tempDir = Path.Combine(Path.GetTempPath(), "GRASP_ProjectConfig_Save_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(tempDir);

            var pc = new ProjectConfig(tempDir);
            pc.SetValue("k1", "v1");
            pc.SetValue("k2", "v2");
            bool ok = pc.Save();
            Assert.True(ok, "Save should succeed.");

            string file = Path.Combine(tempDir, "project.grasp");
            Assert.True(File.Exists(file), "project.grasp must exist after Save.");

            var lines = File.ReadAllLines(file);
            Assert.Contains("k1=v1", lines);
            Assert.Contains("k2=v2", lines);

            // cleanup
            try { if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true); } catch { }
        }
    }
}
