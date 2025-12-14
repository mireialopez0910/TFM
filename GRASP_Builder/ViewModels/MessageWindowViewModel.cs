using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tmds.DBus.Protocol;

namespace GRASP_Builder.ViewModels
{
    public class MessageWindowViewModel : ViewModelBase
    {
        #region Members

        private string _message="Message for visualizing during design\n This will not be seen nevere by user";
        private string _title;
        private bool _isError;
        private bool _isWarning;

        #endregion

        #region Constructor

        public MessageWindowViewModel(string message, string title, bool isError , bool isWarning)
        {
            _message = message;
            _title = title;
            _isError = isError;
            _isWarning = isWarning;
        }

        #endregion

        #region Binding

        public string Message
        {
            get => _message;
            set => SetProperty<string>(ref _message, value);
        }

        public string Title
        {
            get => _title;
            set => SetProperty<string>(ref _title, value);
        }

        public bool IsError
        {
            get => _isError;
            set => SetProperty<bool>(ref _isError, value);
        }
        public bool IsWarning
        {
            get => _isWarning;
            set => SetProperty<bool>(ref _isWarning, value);
        }

        #endregion
    }
}
