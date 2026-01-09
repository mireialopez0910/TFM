using System;
using System.IO;
using System.IO.Compression;
using System.Threading.Tasks;
using Xunit;
using GRASP_Builder.ViewModels.ProjectActions;

namespace UnitTests
{
    public class ManageProjects
    {
        [Fact]
        public async Task CreateProject()
        {
            string baseDir = Path.Combine(Path.GetTempPath(), "GRASP_Test_Create_" + Guid.NewGuid().ToString("N"));
            string projectName = "TestProject_Create";

            try
            {
                var action = new CreateProjectAction
                {
                    DirectoryPath = baseDir,
                    ProjectName = projectName
                };

                bool res = await action.Execute();

                Assert.True(res, "CreateProject action should succeed.");
                string projectRoot = Path.Combine(baseDir, projectName);
                Assert.True(Directory.Exists(projectRoot), "Project directory must be created.");
                string marker = Path.Combine(projectRoot, "project.grasp");
                Assert.True(File.Exists(marker), "project.grasp must exist.");
                string content = File.ReadAllText(marker);
                Assert.Contains(projectName, content);
            }
            finally
            {
                try { if (Directory.Exists(baseDir)) Directory.Delete(baseDir, true); } catch { }
            }
        }

        [Fact]
        public async Task OpenProject()
        {
            string projectDir = Path.Combine(Path.GetTempPath(), "GRASP_Test_Open_" + Guid.NewGuid().ToString("N"));
            string projectName = new DirectoryInfo(projectDir).Name;

            try
            {
                Directory.CreateDirectory(projectDir);
                File.WriteAllText(Path.Combine(projectDir, "project.grasp"), $"# GRASP project: {projectName}{Environment.NewLine}");

                var action = new OpenProjectAction
                {
                    DirectoryPath = projectDir
                };

                bool res = await action.Execute();
                Assert.True(res, "OpenProject action should succeed when project.grasp exists.");
                Assert.Equal(projectName, action.ProjectName);
            }
            finally
            {
                try { if (Directory.Exists(projectDir)) Directory.Delete(projectDir, true); } catch { }
            }
        }

        [Fact]
        public async Task ImportProjectData()
        {
            string testRoot = Path.Combine(Path.GetTempPath(), "GRASP_Test_Import_" + Guid.NewGuid().ToString("N"));
            string zipParent = Path.Combine(testRoot, "zipparent");
            string folderToZip = Path.Combine(zipParent, "ImportedProject");
            string zipPath = Path.Combine(testRoot, "importme.zip");
            string expectedDestination = Path.Combine(testRoot, "ImportedProject");

            try
            {
                Directory.CreateDirectory(folderToZip);
                File.WriteAllText(Path.Combine(folderToZip, "project.grasp"), "# test imported project");

                Directory.CreateDirectory(testRoot);
                // Create zip that will contain the top-level folder "ImportedProject"
                ZipFile.CreateFromDirectory(zipParent, zipPath, CompressionLevel.Fastest, includeBaseDirectory: false);

                var action = new ImportProjectAction
                {
                    DirectoryPath = zipPath
                };

                bool res = await action.Execute();
                Assert.True(res, "ImportProject action should succeed for a valid zip.");
                Assert.True(Directory.Exists(expectedDestination), "Imported project folder must exist at destination.");
                Assert.True(File.Exists(Path.Combine(expectedDestination, "project.grasp")), "project.grasp must be present in imported folder.");
            }
            finally
            {
                try { if (Directory.Exists(testRoot)) Directory.Delete(testRoot, true); } catch { }
                try { if (File.Exists(zipPath)) File.Delete(zipPath); } catch { }
            }
        }
    }
}