using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Threading;
using System;
using System.Threading.Tasks;

namespace GRASP_Builder
{
    public static class MessagesController
    {
        /// <summary>
        /// Shows the message window asynchronously on the UI thread and returns the dialog result.
        /// Safe to call from any thread.
        /// </summary>
        public static Task<bool> ShowMessage(string message, string title, bool isError = false, bool isWarning = false)
        {
            var desktop = App.Current?.ApplicationLifetime as IClassicDesktopStyleApplicationLifetime;
            var owner = desktop?.MainWindow;
            var dialog = new MessageWindow(message, title, isError: isError, isWarning: isWarning);
            // Return the task produced by the window so callers can await it.
            return dialog.ShowDialog<bool>(owner);
        }


        /// <summary>
        /// Synchronous wrapper safe to call from background threads without freezing the UI.
        /// If called from the UI thread it will show the dialog asynchronously and return immediately (true),
        /// because blocking the UI thread would freeze the application.
        /// If called from a background thread it schedules the dialog on the UI thread and blocks
        /// the background thread until the dialog completes, returning the dialog result.
        /// </summary>
        public static bool Show(string message, string title, bool isError = false, bool isWarning = false)
        {
            // If already on UI thread, do not block: show async and return immediately.
            if (Dispatcher.UIThread.CheckAccess())
            {
                _ = ShowMessage(message, title, isError, isWarning);
                return true;
            }

            // We're on a background thread: schedule the dialog on UI thread and wait for completion.
            var tcs = new TaskCompletionSource<bool>(TaskCreationOptions.RunContinuationsAsynchronously);

            // Post action to UI thread. Use Post to avoid complexities with nested tasks/Dispatcher operations.
            Dispatcher.UIThread.Post(async () =>
            {
                try
                {
                    var result = await ShowMessage(message, title, isError, isWarning).ConfigureAwait(false);
                    tcs.TrySetResult(result);
                }
                catch (Exception ex)
                {
                    // Log and return false to caller instead of throwing from this helper.
                    Logger.Log($"MessagesController.Show (UI) failed: {ex.Message}");
                    tcs.TrySetResult(false);
                }
            });

            try
            {
                // Block the calling background thread until UI dialog finishes.
                return tcs.Task.GetAwaiter().GetResult();
            }
            catch (Exception ex)
            {
                // Do not throw from UI helpers; log and return false as fallback.
                Logger.Log($"MessagesController.Show failed: {ex.Message}");
                return false;
            }
        }
    }
}