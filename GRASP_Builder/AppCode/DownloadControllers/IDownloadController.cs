using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder.AppCode.DownloadControllers
{
    public interface IDownloadController
    {
        public string _repositoryDirectory { get; set; }
        public string _workingDirectory { get; set; }
        public Task Download(DateTime FromDate, DateTime ToDate,  string station);
    }
}
