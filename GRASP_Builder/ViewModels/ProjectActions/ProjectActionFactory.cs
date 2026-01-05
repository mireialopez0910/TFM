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
                default:
                    throw new NotSupportedException($"File type {type.ToString()} is not supported");
            }
        }
    }
}
