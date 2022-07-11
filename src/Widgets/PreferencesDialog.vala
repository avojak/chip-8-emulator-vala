/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Widgets.PreferencesDialog : Granite.Dialog {

    public CHIP8.MainWindow main_window {get; construct; }

    public PreferencesDialog (CHIP8.MainWindow main_window) {
        Object (
            title: _("%s Preferences").printf (Constants.APP_NAME),
            deletable: false,
            resizable: false,
            transient_for: main_window,
            modal: false,
            main_window: main_window
        );
    }

    construct {
        var instruction_frequency_label = new Gtk.Label (_("Instruction frequency:")) {
            halign = Gtk.Align.END
        };
        var instruction_frequency_spin_button = create_spin_button (100, 1000, CHIP8.Application.settings.instruction_frequency);
        CHIP8.Application.settings.bind ("instruction-frequency", instruction_frequency_spin_button, "value", GLib.SettingsBindFlags.DEFAULT);
        var instruction_frequency_units_label = new Gtk.Label (_("Hz")) {
            halign = Gtk.Align.START
        };

        var color_palette_label = new Gtk.Label (_("Color palette:")) {
            halign = Gtk.Align.END
        };
        var foreground_color_button = new Gtk.ColorButton.with_rgba (get_color (CHIP8.Application.settings.foreground_color));
        foreground_color_button.color_set.connect (() => {
            CHIP8.Application.settings.foreground_color = foreground_color_button.rgba.to_string ();
        });
        var background_color_button = new Gtk.ColorButton.with_rgba (get_color (CHIP8.Application.settings.background_color));
        background_color_button.color_set.connect (() => {
            CHIP8.Application.settings.background_color = background_color_button.rgba.to_string ();
        });

        var color_grid = new Gtk.Grid () {
            column_spacing = 10
        };
        color_grid.attach (foreground_color_button, 0, 0);
        color_grid.attach (background_color_button, 1, 0);

        var grid = new Gtk.Grid () {
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 10,
            column_spacing = 10,
            row_spacing = 10
        };
        grid.attach (instruction_frequency_label, 0, 0);
        grid.attach (instruction_frequency_spin_button, 1, 0);
        grid.attach (instruction_frequency_units_label, 2, 0);
        grid.attach (color_palette_label, 0, 1);
        grid.attach (color_grid, 1, 1, 2, 1);
        get_content_area ().add (grid);

        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.clicked.connect (() => {
            close ();
        });
        var defaults_button = new Gtk.Button.with_label (_("Restore Defaults"));
        defaults_button.clicked.connect (() => {
            // Update settings values
            CHIP8.Application.settings.instruction_frequency = CHIP8.Application.settings.get_default_value ("instruction-frequency").get_double ();
            CHIP8.Application.settings.background_color = CHIP8.Application.settings.get_default_value ("background-color").get_string ();
            CHIP8.Application.settings.foreground_color = CHIP8.Application.settings.get_default_value ("foreground-color").get_string ();
            // Update widgets
            background_color_button.set_rgba (get_color (CHIP8.Application.settings.background_color));
            foreground_color_button.set_rgba (get_color (CHIP8.Application.settings.foreground_color));
        });

        add_action_widget (defaults_button, 0);
        add_action_widget (close_button, 0);
    }

    private Gdk.RGBA get_color (string color_string) {
        var color = Gdk.RGBA ();
        color.parse (color_string);
        return color;
    }

    private Gtk.SpinButton create_spin_button (double min_value, double max_value, double default_value) {
        var button = new Gtk.SpinButton.with_range (min_value, max_value, 1.0) {
            halign = Gtk.Align.START
        };
        button.set_value (default_value);
        return button;
    }

}
