using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GRASP_Builder
{
    public class Messenger
    {
        private static readonly Messenger _instance = new Messenger();
        public static Messenger Default => _instance;

        // Store keyword → list of delegates
        private readonly Dictionary<string, List<Delegate>> _recipients
            = new Dictionary<string, List<Delegate>>();

        private Messenger() { }

        public void Register<T>(string keyword, Action<T> action)
        {
            if (!_recipients.ContainsKey(keyword))
                _recipients[keyword] = new List<Delegate>();

            _recipients[keyword].Add(action);
        }

        public void Unregister<T>(string keyword, Action<T> action)
        {
            if (_recipients.ContainsKey(keyword))
            {
                _recipients[keyword].Remove(action);
                if (_recipients[keyword].Count == 0)
                    _recipients.Remove(keyword);
            }
        }

        public void Send<T>(string keyword, T message)
        {
            if (_recipients.ContainsKey(keyword))
            {
                foreach (var del in _recipients[keyword])
                {
                    if (del is Action<T> action)
                    {
                        action(message);
                    }
                }
            }
        }
    }

}

/* Messenger.Default.Register<int>("CountChanged", OnCountChanged);
 * Messenger.Default.Register<string>("Status", OnStatusChanged);
 * 
 * Messenger.Default.Send<int>("CountChanged", 42);
 * Messenger.Default.Send<string>("Status", "Loading complete");
 * 
 * 
 * private void OnCountChanged(int count)
 * {
 *    Console.WriteLine($"Count changed to {count}");
 * }
 * 
 * private void OnStatusChanged(string status)
 * {
 *   Console.WriteLine($"Status: {status}");
 * }
 * 
 */