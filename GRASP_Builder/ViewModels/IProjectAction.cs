using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.ViewModels
{
    public interface IProjectAction
    {
        public string Title { get; set; }
        public string ProjectName { get; set; }
        public string DirectoryPath { get; set; }
        public bool IsProjectNameVisible { get; set; }
        public void Execute();
        public Task Browse();
    }
}
