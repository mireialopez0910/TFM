using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels.ProjectActions
{
    public interface IProjectAction
    {
        public string Title { get; set; }
        public string ProjectName { get; set; }
        public string DirectoryPath { get; set; }
        public bool IsProjectNameVisible { get; set; }
        public bool IsDirectoryPathVisible { get; set; }
        public Task<bool> Execute();
        public Task Browse();
    }
}
