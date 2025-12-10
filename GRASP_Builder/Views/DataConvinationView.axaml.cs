using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using GRASP_Builder.ViewModels;
using System.Collections.ObjectModel;

namespace GRASP_Builder;

public partial class DataConvinationView : UserControl
{
    public DataConvinationView()
    {
        InitializeComponent();
        DataContext = new DataConvinationViewModel();

        Messenger.Default.Register<string>("WriteMatlabOutput", WriteMatlabOutput);
        Messenger.Default.Register<string>("WriteMatlabErrors", WriteMatlabErrors);
    }

    private void WriteMatlabOutput(string message)
    {
        Dispatcher.UIThread.Post(() =>
        {
            OutputWindow.Text += message + "\n";
            OutputWindow.CaretIndex = OutputWindow.Text.Length;
        });
    }

    private void WriteMatlabErrors(string message)
    {
        Dispatcher.UIThread.Post(() =>
        {
            ErrorsWindow.Text += message + "\n";
            ErrorsWindow.CaretIndex = ErrorsWindow.Text.Length;
        });
    }
}