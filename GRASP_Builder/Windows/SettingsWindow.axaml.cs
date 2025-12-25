using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder;

public partial class SettingsWindow : Window
{
    public SettingsWindow()
    {
        InitializeComponent();
        DataContext = new ConfigurationViewModel();
    }
    private void Save_Click(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        Close();
    }
}