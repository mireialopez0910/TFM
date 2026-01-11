using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder;

public partial class SHome : UserControl
{
    public SHome()
    {
        InitializeComponent();
        DataContext = new HomeViewModel();
    }
}