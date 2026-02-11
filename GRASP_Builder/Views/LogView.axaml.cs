
using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Avalonia.Threading;
using GRASP_Builder.ViewModels;
using System;
using System.Collections.ObjectModel;

namespace GRASP_Builder;

public partial class LogView : UserControl
{
    public LogView()
    {
        InitializeComponent();

        Messenger.Default.Register<string>("WriteLogMessage", WriteLogMessage);
    }

    private void WriteLogMessage(string message)
    {
        Dispatcher.UIThread.Post(() =>
        {
            LogWindow.Text += message + "\n";
            LogWindow.CaretIndex = LogWindow.Text.Length;
        });
    }

    private void SaveInFile(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        string path = $"Log_{DateTime.Now.ToString("ddMMyyyy")}.txt";
        System.IO.File.WriteAllText(path, LogWindow.Text);
    }

    private void ClearLog(object? sender, Avalonia.Interactivity.RoutedEventArgs e)
    {
        LogWindow.Text = string.Empty;
    }
}
