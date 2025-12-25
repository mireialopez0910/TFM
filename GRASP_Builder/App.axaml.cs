using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Data.Core;
using Avalonia.Data.Core.Plugins;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using GRASP_Builder.AppCode;
using GRASP_Builder.ViewModels;
using GRASP_Builder.Views;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace GRASP_Builder
{
    public partial class App : Application
    {
        public List<string> measureIDFolders { get; set; } = new List<string>();
        public ProjectConfig? CurrentProjectConfig { get; set; }

        public override void Initialize()
        {
            AvaloniaXamlLoader.Load(this);
            RequestedThemeVariant = Avalonia.Styling.ThemeVariant.Light;
        }

        public override async void OnFrameworkInitializationCompleted()
        {
            if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
            {
                var splash = new SplashScreen();
                desktop.MainWindow = splash;
                splash.Show();

                await Task.Delay(3000);

                var main = new MainWindow();
                desktop.MainWindow = main;
                main.Show();

                splash.Close();
                
            }

            base.OnFrameworkInitializationCompleted();
        }

        private void DisableAvaloniaDataAnnotationValidation()
        {
            // Get an array of plugins to remove
            var dataValidationPluginsToRemove =
                BindingPlugins.DataValidators.OfType<DataAnnotationsValidationPlugin>().ToArray();

            // remove each entry found
            foreach (var plugin in dataValidationPluginsToRemove)
            {
                BindingPlugins.DataValidators.Remove(plugin);
            }
        }
    }
}