using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder;

public partial class PlotView : UserControl
{
    public PlotView()
    {
        InitializeComponent();
        DataContext = new PlotViewModel();

        Messenger.Default.Register<string>("WriteMatlabOutput_Plot", WriteMatlabOutput);
        Messenger.Default.Register<string>("WriteMatlabErrors_Plot", WriteMatlabErrors);
        Messenger.Default.Register<bool>("UpdateProjectLoaded", UpdateProjectLoaded);
    }

    private void UpdateProjectLoaded(bool obj)
    {
        Dispatcher.UIThread.Post(() =>
        {
            OutputWindow.Text = string.Empty;

            ErrorsWindow.Text = string.Empty;
        });
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