using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace GRASP_Builder;

public partial class MessageWindow : Window
{
    public MessageWindow(string message, string title, bool isError = false, bool isWarning = false)
    {
        InitializeComponent();
        DataContext = new ViewModels.MessageWindowViewModel(message, title, isError, isWarning);
    }

    private void Ok_Click(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        Close(true);   // return true as DialogResult
    }
    private void Cancel_Click(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        Close(false);  // return false as DialogResult
    }
}