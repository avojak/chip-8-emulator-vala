/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.MainWindow : Hdy.Window {

    public unowned CHIP8.Application app { get; construct; }

    private CHIP8.Widgets.PreferencesDialog? preferences_dialog;
    private CHIP8.Widgets.ControlsDialog? controls_dialog;

    private CHIP8.ActionManager action_manager;
    private Gtk.AccelGroup accel_group;
    private CHIP8.MainLayout main_layout;

    private CHIP8.Emulator? emulator;

    public MainWindow (CHIP8.Application application) {
        Object (
            title: Constants.APP_NAME,
            application: application,
            app: application,
            border_width: 0,
            resizable: true,
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        accel_group = new Gtk.AccelGroup ();
        add_accel_group (accel_group);
        action_manager = new CHIP8.ActionManager (app, this);

        main_layout = new CHIP8.MainLayout (this);
        add (main_layout);

        //  var geometry = Gdk.Geometry ();
        //  geometry.min_width = CHIP8.Graphics.PPU.WIDTH;
        //  geometry.min_height = CHIP8.Graphics.PPU.HEIGHT;
        //  geometry.min_aspect = ((double) CHIP8.Graphics.PPU.WIDTH) / ((double) CHIP8.Graphics.PPU.HEIGHT);
        //  geometry.max_aspect = ((double) CHIP8.Graphics.PPU.WIDTH) / ((double) CHIP8.Graphics.PPU.HEIGHT);
        //  geometry.width_inc = CHIP8.Graphics.PPU.WIDTH;
        //  geometry.height_inc = CHIP8.Graphics.PPU.HEIGHT;
        //  set_geometry_hints (this, geometry, Gdk.WindowHints.MIN_SIZE | Gdk.WindowHints.ASPECT | Gdk.WindowHints.RESIZE_INC);

        move (CHIP8.Application.settings.get_int ("pos-x"), CHIP8.Application.settings.get_int ("pos-y"));
        resize (CHIP8.Application.settings.get_int ("window-width"), CHIP8.Application.settings.get_int ("window-height"));

        //  this.check_resize.connect (() => {
        //      int width, height;
        //      get_size (out width, out height);
        //      debug ("width: %d, height: %d", width, height);
        //      debug ("width: %d, height: %d", main_layout.header_bar.width_request, main_layout.header_bar.height_request);
        //  });

        this.destroy.connect (() => {
            // Do stuff before closing the application

            // Stop running emulator
            if (emulator != null) {
                emulator.stop ();
            }

            //  GLib.Process.exit (0);
        });

        this.delete_event.connect (before_destroy);

        main_layout.start_button_clicked.connect (on_start_button_clicked);
        main_layout.stop_button_clicked.connect (on_stop_button_clicked);

        this.key_press_event.connect ((event_key) => {
            var keyboard_key = event_key.str.up ()[0];
            if (emulator != null) {
                emulator.key_pressed (keyboard_key);
            }
        });
        this.key_release_event.connect ((event_key) => {
            var keyboard_key = event_key.str.up ()[0];
            if (emulator != null) {
                emulator.key_released (keyboard_key);
            }
        });

        show_app ();
    }

    public void show_app () {
        show_all ();
        show ();
        present ();
    }

    public bool before_destroy () {
        update_position_settings ();
        destroy ();
        return true;
    }

    private void update_position_settings () {
        int width, height, x, y;

        get_size (out width, out height);
        get_position (out x, out y);

        CHIP8.Application.settings.pos_x = x;
        CHIP8.Application.settings.pos_y = y;
        CHIP8.Application.settings.window_width = width;
        CHIP8.Application.settings.window_height = height;
    }

    public void on_start_button_clicked (string rom_uri) {
        if (emulator != null) {
            return;
        }
        emulator = new CHIP8.Emulator ();
        emulator.load_rom (GLib.File.new_for_uri (rom_uri));
        emulator.closed.connect (() => {
            emulator = null;
        });
        //  emulator.show (this);
        main_layout.set_emulator_display (emulator.get_display ());
        emulator.start ();
    }

    public void on_stop_button_clicked () {
        if (emulator == null) {
            return;
        }
        emulator.stop ();
        main_layout.remove_emulator_display (emulator.get_display ());
        //  emulator.hide ();
        emulator = null;
    }

    public void show_preferences_dialog () {
        if (preferences_dialog == null) {
            preferences_dialog = new CHIP8.Widgets.PreferencesDialog (this);
            preferences_dialog.show_all ();
            preferences_dialog.destroy.connect (() => {
                preferences_dialog = null;
            });
        }
        preferences_dialog.present ();
    }

    public void show_controls_dialog () {
        if (controls_dialog == null) {
            controls_dialog = new CHIP8.Widgets.ControlsDialog (this);
            controls_dialog.show_all ();
            controls_dialog.destroy.connect (() => {
                controls_dialog = null;
            });
        }
        controls_dialog.present ();
    }

    public void show_rom_popover () {
        main_layout.show_rom_popover ();
    }

}
