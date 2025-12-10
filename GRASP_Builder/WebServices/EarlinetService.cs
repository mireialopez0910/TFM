using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net.Http;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder
{
    public class EarlinetService
    {
        string baseUrl = "https://api.actris-ares.eu/api/services/restapi/";
        public virtual System.Threading.Tasks.Task<bool> DownloadProductByDateRangeAsync(string type, string FromDate, string ToDate, string outputFolder)
        {
            return DownloadProductByDateRangeAsync(type, FromDate, ToDate, outputFolder, System.Threading.CancellationToken.None);
        }

        public async Task<bool> DownloadProductByDateRangeAsync(string type, string FromDate, string ToDate, string outputFilePath, System.Threading.CancellationToken cancellationToken = default)
        {
            try
            {
                string url = $"{baseUrl}products/downloads?kind={type}&fromDate={FromDate}&toDate={ToDate}&stations=brc";
                using (HttpClient client = new HttpClient())
                {
                    HttpResponseMessage response = await client.GetAsync(url);
                    response.EnsureSuccessStatusCode();

                    using (var fs = new FileStream(outputFilePath, FileMode.Create, FileAccess.Write, FileShare.None))
                    {
                        await response.Content.CopyToAsync(fs);
                    }

                    System.IO.FileInfo f = new FileInfo(outputFilePath);
                    if (f.Length <= 1048)
                        return false;

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}

#pragma warning restore 1591
#pragma warning restore 1573
#pragma warning restore 472
#pragma warning restore 114
#pragma warning restore 108
#pragma warning restore 3016
#pragma warning restore 8603