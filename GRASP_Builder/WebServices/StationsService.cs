using Avalonia.Controls;
using CommunityToolkit.Mvvm.ComponentModel;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Reflection;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;


namespace GRASP_Builder.WebServices
{
    public class StationsService
    {
        private List<string> stationsList;
        private static string ReadEmbeddedResource(string resourceName)
        {
            var assembly = Assembly.GetExecutingAssembly();

            using Stream stream = assembly.GetManifestResourceStream(resourceName)
                ?? throw new InvalidOperationException($"Resource not found: {resourceName}");

            using StreamReader reader = new StreamReader(stream);
            return reader.ReadToEnd();
        }

        private static List<string> ReadTxtLines()
        {
            string resourceName = "GRASP_Builder.WebServices.aeronet_locations_v3.txt";
            string content = ReadEmbeddedResource(resourceName);
            List<string> stations = new List<string>();

            foreach (var line in content.Split("\n").ToList())
            {
                stations.Add(line.Split(',')[0]);
            }

            return stations;
        }

        private static Dictionary<string, string> ReadStationsDictionary()
        {
            string resourceName = "GRASP_Builder.WebServices.earlinet_stations.json";
            string json = ReadEmbeddedResource(resourceName);

            var stations = JsonSerializer.Deserialize<List<Station>>(json);

            return stations?
                .Where(s => s.ID != null && s.Location != null)
                .ToDictionary(s => s.ID,s => s.Location.Split(",")[0])
                ?? new Dictionary<string, string>();
        }

        public static ObservableCollection<string> GetStations()
        {
            ObservableCollection<string> dict = new ObservableCollection<string>();

            List<string> aeronetStations = ReadTxtLines();
            Dictionary<string, string> earlinetStations = ReadStationsDictionary();

            if (aeronetStations.Count == 0 && earlinetStations.Count == 0)
            {
                throw new InvalidOperationException("No stations data available.");
            }
            foreach (KeyValuePair<string,string> station in earlinetStations)
            {
                if (aeronetStations.Contains(station.Value))
                    dict.Add($"{station.Key} - {station.Value}");
            }
            
            return dict;
        }
    } 

    public class EarlinetStation
    {
        public string ID { get; set; }
        public string Location { get; set; }
    }
}
