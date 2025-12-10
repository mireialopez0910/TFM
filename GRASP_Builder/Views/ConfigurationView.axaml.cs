using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using GRASP_Builder.ViewModels;
using System.Reflection;

namespace GRASP_Builder;

public partial class ConfigurationView : UserControl
{
    public ConfigurationView()
    {
        InitializeComponent();
        DataContext = new ConfigurationViewModel();
    }
}