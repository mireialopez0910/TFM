using GRASP_Builder.ViewModels;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GRASP_Builder.AppCode.DownloadControllers
{
    public class AeronetDownloadController : IDownloadController
    {

        public AeronetDownloadController(string repositoryDirectory, string workingDirectory)
        {
            _repositoryDirectory = repositoryDirectory;
            _workingDirectory = workingDirectory;
        }

        public string _repositoryDirectory { get; set; }
        public string _workingDirectory { get; set; }

        public async Task Download(DateTime FromDate, DateTime ToDate, string station)
        {
            AeronetService _aeronetService = new AeronetService();
            string repositoryDirectory = Path.Combine(_repositoryDirectory, station.Split(" - ")[0]);
            string site = station.Split(" - ")[1];
            if(Directory.Exists(repositoryDirectory))
                Directory.Delete(repositoryDirectory, true);

            Directory.CreateDirectory(repositoryDirectory);

            Logger.Log($"Downloading Aeronet files from date {FromDate.ToString("dd-MM-yyyy")}");

            string url = _aeronetService.BuildUrl(DataType.AerosolInversions, FromDate, ToDate, "ALM15", site);

            string destinationFile = System.IO.Path.Combine(repositoryDirectory, $"{FileType.AeronetInversions.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}_{site}.all");

            await _aeronetService.DescargarDatosAsync(destinationFile, url);
            Logger.Log($"AERONET Aerosol inversion products data have downloaded and saved in file {destinationFile}");

            Messenger.Default.Send<string>("UpdateProgress", "50");

            url = _aeronetService.BuildUrl(DataType.OpticalDepth, FromDate, ToDate, "AOD15", site);

            destinationFile = System.IO.Path.Combine(repositoryDirectory, $"{FileType.AeronetAOD.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}_{site}.lev15");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.lev15

            Logger.Log($"AERONET AOD data have been downloaded and saved in file {destinationFile}");

            Messenger.Default.Send<string>("UpdateProgress", "60");

            url = _aeronetService.BuildUrl(DataType.OpticalDepth, FromDate, ToDate, "SDA15", site);

            destinationFile = System.IO.Path.Combine(repositoryDirectory, $"{FileType.AeronetSDA.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}_{site}.ONEILL_lev15");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.ONEILL_lev15

            Logger.Log($"AERONET Spectral deconvolution algortihm file downloaded & saved in file: " + destinationFile);

            Messenger.Default.Send<string>("UpdateProgress", "70");

            url = _aeronetService.BuildUrl(DataType.RawProductsOpticalDepth, FromDate, ToDate, RawProductsOpticalDepth.ALM00, site);

            destinationFile = System.IO.Path.Combine(repositoryDirectory, $"{FileType.AeronetRawAlmucantar.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}_{site}.alm");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.alm

            Messenger.Default.Send<string>("UpdateProgress", "80");

            Logger.Log($"AERONET Raw Almucantar data have been downloaded and saved in file {destinationFile}");

            url = _aeronetService.BuildUrl(DataType.RawProductsOpticalDepth, FromDate, ToDate, RawProductsOpticalDepth.ALP00, site);

            destinationFile = System.IO.Path.Combine(repositoryDirectory, $"{FileType.AeronetRawPolarizedAlmucantar.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}_{site}.alp");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.alp

            Messenger.Default.Send<string>("UpdateProgress", "90");

            Logger.Log($"AERONET Raw polarized almucantar has been downloaded and saved in file {destinationFile}");
        }

    }
}