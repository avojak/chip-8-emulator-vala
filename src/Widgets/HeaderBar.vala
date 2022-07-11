/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Widgets.HeaderBar : Hdy.HeaderBar {

    private CHIP8.Widgets.RomButton rom_button;
    private Gtk.Button start_button;
    private Gtk.Button stop_button;

    public HeaderBar () {
        Object (
            title: Constants.APP_NAME,
            show_close_button: true,
            has_subtitle: false
        );
    }

    construct {
        rom_button = new CHIP8.Widgets.RomButton () {
            margin_end = 8
        };
        rom_button.rom_file_selected.connect (() => {
            start_button.sensitive = true;
        });

        start_button = new Gtk.Button.from_icon_name ("media-playback-start", Gtk.IconSize.SMALL_TOOLBAR) {
            tooltip_text = _("Start"),
            relief = Gtk.ReliefStyle.NONE,
            valign = Gtk.Align.CENTER
        };
        start_button.clicked.connect (() => {
            if (rom_button.selected_rom_file != null) {
                start_button_clicked (rom_button.selected_rom_file.get_uri ());
                set_start_button_visible (false);
                set_stop_button_visible (true);
                rom_button.sensitive = false;
            }
        });
        stop_button = new Gtk.Button.from_icon_name ("media-playback-stop", Gtk.IconSize.SMALL_TOOLBAR) {
            tooltip_text = _("Stop"),
            relief = Gtk.ReliefStyle.NONE,
            valign = Gtk.Align.CENTER
        };
        stop_button.clicked.connect (() => {
            stop_button_clicked ();
            set_stop_button_visible (false);
            set_start_button_visible (true);
            rom_button.sensitive = true;
        });

        var preferences_accellabel = new Granite.AccelLabel.from_action_name (
            _("Preferences…"),
            CHIP8.ActionManager.ACTION_PREFIX + CHIP8.ActionManager.ACTION_PREFERENCES
        );

        var preferences_menu_item = new Gtk.ModelButton () {
            action_name = CHIP8.ActionManager.ACTION_PREFIX + CHIP8.ActionManager.ACTION_PREFERENCES
        };
        preferences_menu_item.get_child ().destroy ();
        preferences_menu_item.add (preferences_accellabel);

        var help_accellabel = new Granite.AccelLabel.from_action_name (
            _("Help…"),
            CHIP8.ActionManager.ACTION_PREFIX + CHIP8.ActionManager.ACTION_HELP
        );

        var help_menu_item = new Gtk.ModelButton () {
            action_name = CHIP8.ActionManager.ACTION_PREFIX + CHIP8.ActionManager.ACTION_HELP
        };
        help_menu_item.get_child ().destroy ();
        help_menu_item.add (help_accellabel);

        var quit_accellabel = new Granite.AccelLabel.from_action_name (
            _("Quit"),
            CHIP8.ActionManager.ACTION_PREFIX + CHIP8.ActionManager.ACTION_QUIT
        );

        var quit_menu_item = new Gtk.ModelButton () {
            action_name = CHIP8.ActionManager.ACTION_PREFIX + CHIP8.ActionManager.ACTION_QUIT
        };
        quit_menu_item.get_child ().destroy ();
        quit_menu_item.add (quit_accellabel);

        var menu_popover_grid = new Gtk.Grid () {
            margin_top = 3,
            margin_bottom = 3,
            orientation = Gtk.Orientation.VERTICAL,
            width_request = 200
        };
        menu_popover_grid.attach (preferences_menu_item, 0, 0);
        menu_popover_grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 1);
        menu_popover_grid.attach (help_menu_item, 0, 2);
        menu_popover_grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 3);
        menu_popover_grid.attach (quit_menu_item, 0, 4);
        menu_popover_grid.show_all ();

        var menu_popover = new Gtk.Popover (null);
        menu_popover.add (menu_popover_grid);

        var menu_button = new Gtk.MenuButton () {
            image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR),
            tooltip_text = _("Menu"),
            relief = Gtk.ReliefStyle.NONE,
            valign = Gtk.Align.CENTER,
            popover = menu_popover
        };

        var control_grid = new Gtk.Grid ();
        control_grid.attach (rom_button, 0, 0);
        control_grid.attach (start_button, 1, 0);
        control_grid.attach (stop_button, 2, 0);

        set_custom_title (control_grid);

        pack_end (menu_button);

        set_start_button_visible (true);
        set_stop_button_visible (false);

        start_button.sensitive = false;
    }

    public void set_start_button_visible (bool visible) {
        start_button.sensitive = visible;
        start_button.no_show_all = !visible;
        start_button.visible = visible;
    }

    public void set_stop_button_visible (bool visible) {
        stop_button.sensitive = visible;
        stop_button.no_show_all = !visible;
        stop_button.visible = visible;
    }

    public void show_rom_popover () {
        rom_button.clicked ();
    }

    public signal void start_button_clicked (string rom_uri);
    public signal void stop_button_clicked ();

}
