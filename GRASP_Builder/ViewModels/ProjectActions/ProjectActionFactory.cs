using GRASP_Builder.Matlab;
using GRASP_Builder.Matlab.MatlabScriptsImplementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public class ProjectActionFactory
    {
        public static IProjectAction Create(string type)
        {
            switch (type)
            {
                case "Create":
                    return new CreateProjectAction();
                case "Open":
                    return new OpenProjectAction();
                case "Import":
                    return new ImportProjectAction();
                case "Export":
                    IProjectAction _projectAction = new ExportProjectAction();
                    _projectAction.DirectoryPath = AppConfig.Instance.GetValue("ProjectDirectoryPath");
                    _projectAction.ProjectName = new System.IO.DirectoryInfo(_projectAction.DirectoryPath).Name;
                    return _projectAction;
                default:
                    throw new NotSupportedException($"File type {type.ToString()} is not supported");
            }
        }
    }
}
