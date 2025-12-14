using System.Reflection;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder.Views;

public partial class HomeProjectActionWindow : Window
{
    public HomeProjectActionWindow(string type)
    {
        InitializeComponent();
        DataContext = new HomeProjectActionViewModel(type);
        Messenger.Default.Register<bool>("CloseHomeProjectActionWindow", CloseWindow);
    }

    private  void CloseWindow(bool result)
    {
        Close(result);
    }

    private void Cancel_Click(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        Close(false);  // return false as DialogResult
    }
}