using Avalonia.Controls;
using GRASP_Builder.ViewModels;
using System.Diagnostics;
using System.IO;

namespace GRASP_Builder.Views
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            DataContext = new MainWindowViewModel();
        }

        private void Help_Click(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
        {
            string filePath = Path.Combine(Directory.GetCurrentDirectory(), "Resources", "UserManual.pdf");

            if (System.IO.File.Exists(filePath))
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = filePath,
                    UseShellExecute = true // Crucial for non-executable files like PDFs
                };
                Process.Start(psi);
            }
        }
    }
}