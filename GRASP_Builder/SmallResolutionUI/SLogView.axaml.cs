using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;

namespace GRASP_Builder;

public partial class SLogView : UserControl
{
    public SLogView()
    {
        InitializeComponent();

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