/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.MainLayout : Gtk.Grid {

    public unowned CHIP8.MainWindow window { get; construct; }

    private CHIP8.Widgets.HeaderBar header_bar;
    private Gtk.Stack stack;
    //  private Gtk.Grid control_container;
    private Gtk.Grid emulator_display_container;
    //  private Gtk.Grid emulator_debug_container;

    public MainLayout (CHIP8.MainWindow window) {
        Object (
            window: window
        );
    }

    construct {
        header_bar = new CHIP8.Widgets.HeaderBar ();
        header_bar.get_style_context ().add_class ("default-decoration");
        header_bar.start_button_clicked.connect ((rom_uri) => {
            start_button_clicked (rom_uri);
            stack.set_visible_child_name ("emulator");
        });
        header_bar.stop_button_clicked.connect (() => {
            stop_button_clicked ();
            stack.set_visible_child_name ("welcome");
        });

        //  var rom_file_entry = new Gtk.FileChooserButton (_("Select ROM File\u2026"), Gtk.FileChooserAction.OPEN);
        //  rom_file_entry.hexpand = true;
        //  rom_file_entry.sensitive = true;
        //  rom_file_entry.set_uri (GLib.Environment.get_home_dir ());

        //  control_container = new Gtk.Grid () {
        //      hexpand = true,
        //      column_spacing = 8,
        //      row_spacing = 8,
        //      margin = 8
        //  };
        //  control_container.attach (rom_file_entry, 0, 0);
        //  control_container.attach (start_button, 1, 0);
        //  control_container.attach (stop_button, 2, 0);

        emulator_display_container = new Gtk.Grid () {
            expand = true,
            //  margin = 8,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        };

        stack = new Gtk.Stack ();
        stack.add_named (new CHIP8.Views.WelcomeView (window), "welcome");
        stack.add_named (emulator_display_container, "emulator");

        //  emulator_debug_container = new Gtk.Grid ();

        //  var emulator_container = new Gtk.Grid () {
        //      expand = true
        //  };
        //  emulator_container.attach (emulator_display_container, 0, 0);
        //  emulator_container.attach (emulator_debug_container, 1, 0);

        attach (header_bar, 0, 0);
        attach (stack, 0, 1);

        show_all ();
    }

    public void set_emulator_display (Gtk.Container display) {
        emulator_display_container.attach (display, 0, 0);
    }

    public void remove_emulator_display (Gtk.Container display) {
        emulator_display_container.remove (display);
    }

    public void show_rom_popover () {
        header_bar.show_rom_popover ();
    }

    //  public void set_emulator_debug_display (Gtk.Container debug_display) {
    //      emulator_debug_container.attach (debug_display, 0, 0);
    //  }

    //  public void remove_emulator_debug_display (Gtk.Container debug_display) {
    //      emulator_debug_container.remove (debug_display);
    //  }

    public signal void start_button_clicked (string uri_rom);
    public signal void stop_button_clicked ();

    public signal void debug_button_clicked ();

}
