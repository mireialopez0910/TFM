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

            Directory.Delete(_repositoryDirectory, true);
            Directory.CreateDirectory(_repositoryDirectory);

            Logger.Log($"Downloading Aeronet files from date {FromDate.ToString("dd-MM-yyyy")}");

            string url = _aeronetService.BuildUrl(DataType.AerosolInversions, FromDate, ToDate);

            string destinationFile = System.IO.Path.Combine(_repositoryDirectory, $"{FileType.AeronetInversions.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.all");

            await _aeronetService.DescargarDatosAsync(destinationFile, url);
            Logger.Log($"AERONET Aerosol inversion products data have downloaded and saved in file {destinationFile}");

            Messenger.Default.Send<string>("UpdateProgress", "50");

            url = _aeronetService.BuildUrl(DataType.OpticalDepth, FromDate, ToDate, "AOD15");

            destinationFile = System.IO.Path.Combine(_repositoryDirectory, $"{FileType.AeronetAOD.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.lev15");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.lev15

            Logger.Log($"AERONET AOD data have been downloaded and saved in file {destinationFile}");

            Messenger.Default.Send<string>("UpdateProgress", "60");

            url = _aeronetService.BuildUrl(DataType.OpticalDepth, FromDate, ToDate, "SDA15");

            destinationFile = System.IO.Path.Combine(_repositoryDirectory, $"{FileType.AeronetSDA.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.ONEILL_lev15");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.ONEILL_lev15

            Logger.Log($"AERONET Spectral deconvolution algortihm file downloaded & saved in file: " + destinationFile);

            Messenger.Default.Send<string>("UpdateProgress", "70");

            url = _aeronetService.BuildUrl(DataType.RawProductsOpticalDepth, FromDate, ToDate, RawProductsOpticalDepth.ALM00);

            destinationFile = System.IO.Path.Combine(_repositoryDirectory, $"{FileType.AeronetRawAlmucantar.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.alm");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.alm

            Messenger.Default.Send<string>("UpdateProgress", "80");

            Logger.Log($"AERONET Raw Almucantar data have been downloaded and saved in file {destinationFile}");

            url = _aeronetService.BuildUrl(DataType.RawProductsOpticalDepth, FromDate, ToDate, RawProductsOpticalDepth.ALP00);

            destinationFile = System.IO.Path.Combine(_repositoryDirectory, $"{FileType.AeronetRawPolarizedAlmucantar.ToString()}_{FromDate.ToString("ddMMyyyy")}_{ToDate.ToString("ddMMyyyy")}.alp");

            await _aeronetService.DescargarDatosAsync(destinationFile, url); //.alp

            Messenger.Default.Send<string>("UpdateProgress", "90");

            Logger.Log($"AERONET Raw polarized almucantar has been downloaded and saved in file {destinationFile}");
        }

    }
}