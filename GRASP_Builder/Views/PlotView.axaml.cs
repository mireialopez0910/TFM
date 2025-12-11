using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder;

public partial class PlotView : UserControl
{
    public PlotView()
    {
        InitializeComponent();
        DataContext = new PlotViewModel();
    }
}