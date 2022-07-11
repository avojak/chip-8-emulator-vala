/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Widgets.RomButton : Gtk.MenuButton {

    private Gtk.Label label_widget;

    public GLib.File? selected_rom_file { get; set; }

    construct {
        var icon = new Gtk.Image () {
            gicon = GLib.ContentType.get_icon ("application/octet-stream"),
            icon_size = Gtk.IconSize.SMALL_TOOLBAR
        };

        label_widget = new Gtk.Label (_("No ROM Loaded")) {
            width_chars = 24,
            ellipsize = Pango.EllipsizeMode.MIDDLE,
            max_width_chars = 24,
            halign = Gtk.Align.START,
            xalign = 0.0f
        };

        var grid = new Gtk.Grid () {
            halign = Gtk.Align.START
        };
        grid.add (icon);
        grid.add (label_widget);

        add (grid);

        popup = create_rom_popup ();
    }

    private Gtk.Menu create_rom_popup () {
        var menu = new Gtk.Menu ();
        var file_chooser_item = new Gtk.MenuItem.with_label ("Choose ROM file…");
        file_chooser_item.activate.connect (() => {
            var all_files_filter = new Gtk.FileFilter ();
            all_files_filter.set_filter_name (_("All files"));
            all_files_filter.add_pattern ("*");

            var chip8_files_filter = new Gtk.FileFilter ();
            chip8_files_filter.set_filter_name (_("CHIP-8 ROM files"));
            foreach (var extension in CHIP8.Emulator.SUPPORTED_EXTENSIONS) {
                chip8_files_filter.add_pattern (@"*.$extension");
            }

            var file_chooser = new Gtk.FileChooserNative (_("Select ROM File"), null, Gtk.FileChooserAction.OPEN, _("Open"), _("Cancel")) {
                select_multiple = false
            };
            file_chooser.add_filter (chip8_files_filter);
            file_chooser.add_filter (all_files_filter);
            file_chooser.set_current_folder (GLib.Environment.get_home_dir ());

            var response = file_chooser.run ();
            file_chooser.destroy ();

            if (response == Gtk.ResponseType.ACCEPT) {
                on_rom_file_selected (GLib.File.new_for_uri (file_chooser.get_uris ().nth_data (0)));
            }
        });
        menu.add (file_chooser_item);
        var rom_directory = GLib.File.new_for_path (GLib.Path.build_path (GLib.Path.DIR_SEPARATOR_S, Constants.PKG_DATA_DIR, "roms"));
        try {
            GLib.FileEnumerator enumerator = rom_directory.enumerate_children (GLib.FileAttribute.STANDARD_NAME, GLib.FileQueryInfoFlags.NONE);
            GLib.FileInfo? info = enumerator.next_file ();
            if (info != null) {
                menu.add (new Gtk.SeparatorMenuItem ());
            }
            for (; info != null; info = enumerator.next_file ()) {
                var item = new Gtk.MenuItem.with_label (info.get_name ());
                var file = GLib.File.new_for_path (GLib.Path.build_filename (rom_directory.get_path (), info.get_name ()));
                item.activate.connect (() => {
                    on_rom_file_selected (file);
                });
                menu.add (item);
            }
        } catch (GLib.Error e) {
            warning ("Failed to enumerate bundled ROMs: %s", e.message);
        }
        menu.show_all ();
        return menu;
    }

    private void on_rom_file_selected (GLib.File rom_file) {
        label_widget.set_text (rom_file.get_basename ());
        selected_rom_file = rom_file;
        rom_file_selected (rom_file);
    }

    public signal void rom_file_selected (GLib.File rom_file);

}
