
using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using GRASP_Builder.ViewModels;
using System.Collections.ObjectModel;

namespace GRASP_Builder;

public partial class LogView : UserControl
{
    public LogView()
    {
        InitializeComponent();
        DataContext = new LogViewModel();

        Messenger.Default.Register<string>("WriteLogMessage", WriteLogMessage);
    }

    private void WriteLogMessage(string message)
    {
        Dispatcher.UIThread.Post(() =>
        {
            LogWindow.Text += message + "\n";
            LogWindow.CaretIndex = LogWindow.Text.Length;
        });
    }
}
