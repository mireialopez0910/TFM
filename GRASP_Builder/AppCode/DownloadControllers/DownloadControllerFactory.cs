using GRASP_Builder.Matlab;
using GRASP_Builder.Matlab.MatlabScriptsImplementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tmds.DBus.Protocol;

namespace GRASP_Builder.AppCode.DownloadControllers
{
    public class DownloadControllerFactory
    {
        public static IDownloadController Create(DownloadType type, string _repositoryDirectory, string _workingDirectory)
        {
            switch (type)
            {
                case DownloadType.Earlinet:
                    return new EarlinetDownloadController(_repositoryDirectory, _workingDirectory);
                case DownloadType.Aeronet:
                    return new AeronetDownloadController(_repositoryDirectory, _workingDirectory);
                default:
                    throw new NotSupportedException($"Download type {type.ToString()} is not supported");
            }

        }
    }
}

namespace GRASP_Builder
{
    public enum DownloadType
    {
        Earlinet,
        Aeronet
    }
}
