using Avalonia.Controls;
using GRASP_Builder.ViewModels;

namespace GRASP_Builder.Views
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            DataContext = new MainWindowViewModel();
        }
    }
}