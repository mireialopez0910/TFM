using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder;

public partial class SDownloadFiles : UserControl
{
    public SDownloadFiles()
    {
        InitializeComponent();
        DataContext = new DownloadFilesViewModel();
    }
}