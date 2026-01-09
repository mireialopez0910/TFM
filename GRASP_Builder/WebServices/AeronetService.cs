using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GRASP_Builder
{
    public class AeronetService
    {
        private string baseUrl = "https://aeronet.gsfc.nasa.gov/cgi-bin/";
        public async Task DescargarDatosAsync(string destinationFile, string url)
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    var response = await client.GetAsync(url);
                    response.EnsureSuccessStatusCode();

                    var content = await response.Content.ReadAsByteArrayAsync();
                    await File.WriteAllBytesAsync(destinationFile, content);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error downloading data: {ex.Message}");
            }
        }

        public string BuildUrl(DataType _dataType, DateTime startDate, DateTime endDate, string productType = "", string site = "", string product = "", string AVG = "", bool isEnabled = false)
        {
            switch (_dataType)
            {
                case DataType.AerosolInversions:
                    if (isEnabled)
                        return BuildUrlAerosolInversions(startDate, endDate, productType, site, product, AVG);
                    else
                        return BuildUrlAerosolInversions(startDate, endDate, productType, site);

                case DataType.OpticalDepth:
                    if (isEnabled)
                        return BuildUrlOpticalDepth(startDate, endDate, productType, site, AVG);
                    else
                        return BuildUrlOpticalDepth(startDate, endDate, productType, site);

                case DataType.RawProductsOpticalDepth:
                    if (isEnabled)
                        return BuildUrlRawProductsOpticalDepth(startDate, endDate, productType, site, AVG);
                    else
                        return BuildUrlRawProductsOpticalDepth(startDate, endDate, productType, site);
            }

            return "";
        }

        /*
         * Inversion files
         * https://aeronet.gsfc.nasa.gov/print_web_data_help_v3_new.html
         */

        private string BuildUrlAerosolInversions(DateTime fromDate, DateTime toDate, string productType = "ALM15", string site = "Barcelona", string product = "ALL", string AVG = "10")
        {
            string[] _fromDate = fromDate.ToString("yyyy-MM-dd").Split('-');
            string[] _toDate = toDate.ToString("yyyy-MM-dd").Split('-');

            string url = $"{baseUrl}print_web_data_inv_v3?site={site}&year={_fromDate[0]}&month={int.Parse(_fromDate[1])}&day={int.Parse(_fromDate[2])}&year2={_toDate[0]}&month2={int.Parse(_toDate[1])}&day2={int.Parse(_toDate[2])}&product={product}&AVG={AVG}&{productType}=1&if_no_html=1";

            return url;
        }

        /*
         * Output file .all
         * https://aeronet.gsfc.nasa.gov/print_web_data_help_v3_inv_new.html
         */

        private string BuildUrlOpticalDepth(DateTime fromDate, DateTime toDate, string productType = "AOD15", string site = "Barcelona", string AVG = "10")
        {
            string[] _fromDate = fromDate.ToString("yyyy-MM-dd").Split('-');
            string[] _toDate = toDate.ToString("yyyy-MM-dd").Split('-');

            string url = $"{baseUrl}print_web_data_v3?site={site}&year=&year={_fromDate[0]}&month={int.Parse(_fromDate[1])}&day={int.Parse(_fromDate[2])}&year2={_toDate[0]}&month2={int.Parse(_toDate[1])}&day2={int.Parse(_toDate[2])}&{productType}=1&AVG={AVG}&if_no_html=1";

            return url;
        }

        /*
         * Input files .alm & .alp
         * https://aeronet.gsfc.nasa.gov/print_web_data_help_v3_raw_sky_new.html
         */
        private string BuildUrlRawProductsOpticalDepth(DateTime fromDate, DateTime toDate, string productType, string site = "Barcelona", string AVG = "10")
        {
            string[] _fromDate = fromDate.ToString("yyyy-MM-dd").Split('-');
            string[] _toDate = toDate.ToString("yyyy-MM-dd").Split('-');

            string url = $"{baseUrl}print_web_data_raw_sky_v3?site={site}&year=&year={_fromDate[0]}&month={int.Parse(_fromDate[1])}&day={int.Parse(_fromDate[2])}&year2={_toDate[0]}&month2={int.Parse(_toDate[1])}&day2={int.Parse(_toDate[2])}&{productType}=1&AVG={AVG}&if_no_html=1";

            return url;
        }
    }

    public enum DataType
    {
        AerosolInversions,
        OpticalDepth,
        RawProductsOpticalDepth
    }

    public class RawProductsOpticalDepth
    {
        public const string ALM00 = "ALM00"; //Raw Almucantar Sky Scan Radiance
        public const string HYB00 = "HYB00"; //Raw Hybrid Sky Scan Radiance
        public const string PPL00 = "PPL00"; //Raw Principal Plane Sky Scan Radiance
        public const string PPP00 = "PPP00"; //Raw Polarized Principal Plane Sky Scan Radiance and Degree of Polarization
        public const string ALP00 = "ALP00"; //Raw Polarized Almucantar Sky Scan Radiance and Degree of Polarization
        public const string HYP00 = "HYP00"; //Raw Polarized Hybrid Sky Scan Radiance and Degree of Polarization
    }

}
