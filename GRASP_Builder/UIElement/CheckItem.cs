using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace GRASP_Builder.UIElement
{
    public class CheckItem : INotifyPropertyChanged
    {
        private string _name;
        private bool _isChecked;

        public string Name
        {
            get => _name;
            set
            {
                if (_name != value)
                {
                    _name = value;
                    OnPropertyChanged();
                }
            }
        }

        public bool IsChecked
        {
            get => _isChecked;
            set
            {
                if (_isChecked != value)
                {
                    _isChecked = value;
                    OnPropertyChanged();
                    if (value)
                        Messenger.Default.Send<string>("AddMeasureToBeDownloaded", ID);
                    else
                        Messenger.Default.Send<string>("RemoveMeasureToBeDownloaded", ID);
                }
            }
        }

        public string ID { get; set; }

        public string FileName { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

}
