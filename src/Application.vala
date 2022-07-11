/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Application : Gtk.Application {

    public static CHIP8.Settings settings;

    private GLib.List<CHIP8.MainWindow> windows;

    public Application () {
        Object (
            application_id: Constants.APP_ID,
            flags: ApplicationFlags.HANDLES_COMMAND_LINE
        );
    }

    static construct {
        info ("%s version: %s", Constants.APP_ID, Constants.VERSION);
        info ("Kernel version: %s", Posix.utsname ().release);
    }

    construct {
        settings = new CHIP8.Settings ();
        windows = new GLib.List<CHIP8.MainWindow> ();

        startup.connect ((handler) => {
            Hdy.init ();
        });
    }

    public override void window_added (Gtk.Window window) {
        windows.append (window as CHIP8.MainWindow);
        base.window_added (window);
    }

    public override void window_removed (Gtk.Window window) {
        windows.remove (window as CHIP8.MainWindow);
        base.window_removed (window);
    }

    private CHIP8.MainWindow add_new_window () {
        var window = new CHIP8.MainWindow (this);
        this.add_window (window);
        return window;
    }

    protected override int command_line (ApplicationCommandLine command_line) {
        string[] command_line_arguments = parse_command_line_arguments (command_line.get_arguments ());
        // If the application wasn't already open, activate it now
        if (windows.length () == 0) {
            //  queued_command_line_arguments = command_line_arguments;
            activate ();
        } else {
            handle_command_line_arguments (command_line_arguments);
        }
        return 0;
    }

    private string[] parse_command_line_arguments (string[] command_line_arguments) {
        if (command_line_arguments.length == 0) {
            return command_line_arguments;
        } else {
            // For Flatpak, the first commandline argument is the app ID, so we need to filter it out
            if (command_line_arguments[0] == Constants.APP_ID) {
                return command_line_arguments[1:command_line_arguments.length - 1];
            } {
                return command_line_arguments;
            }
        }
    }

    private void handle_command_line_arguments (string[] argv) {
    }

    protected override void activate () {
        // Respect the system style preference
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });

        this.add_new_window ();
    }

    public static int main (string[] args) {
        var app = new CHIP8.Application ();
        return app.run (args);
    }

}
