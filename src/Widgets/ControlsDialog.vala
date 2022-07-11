/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com>
 */

public class CHIP8.Widgets.ControlsDialog : Granite.Dialog {

    private class Key : Gtk.Label {
        public Key (string label) {
            Object (
                label: label
            );
        }

        construct {
            get_style_context ().add_class (Granite.STYLE_CLASS_KEYCAP);
        }
    }

    public ControlsDialog (CHIP8.MainWindow main_window) {
        Object (
            title: _("%s Controls").printf (Constants.APP_NAME),
            deletable: false,
            resizable: false,
            transient_for: main_window,
            modal: false
        );
    }

    construct {
        var keypad = new Gtk.Grid () {
            column_spacing = 4,
            row_spacing = 4
        };
        keypad.attach (new Key ("1"), 0, 0);
        keypad.attach (new Key ("2"), 1, 0);
        keypad.attach (new Key ("3"), 2, 0);
        keypad.attach (new Key ("C"), 3, 0);
        keypad.attach (new Key ("4"), 0, 1);
        keypad.attach (new Key ("5"), 1, 1);
        keypad.attach (new Key ("6"), 2, 1);
        keypad.attach (new Key ("D"), 3, 1);
        keypad.attach (new Key ("7"), 0, 2);
        keypad.attach (new Key ("8"), 1, 2);
        keypad.attach (new Key ("9"), 2, 2);
        keypad.attach (new Key ("E"), 3, 2);
        keypad.attach (new Key ("A"), 0, 3);
        keypad.attach (new Key ("0"), 1, 3);
        keypad.attach (new Key ("B"), 2, 3);
        keypad.attach (new Key ("F"), 3, 3);

        var keyboard = new Gtk.Grid () {
            column_spacing = 4,
            row_spacing = 4
        };
        keyboard.attach (new Key ("1"), 0, 0);
        keyboard.attach (new Key ("2"), 1, 0);
        keyboard.attach (new Key ("3"), 2, 0);
        keyboard.attach (new Key ("4"), 3, 0);
        keyboard.attach (new Key ("Q"), 0, 1);
        keyboard.attach (new Key ("W"), 1, 1);
        keyboard.attach (new Key ("E"), 2, 1);
        keyboard.attach (new Key ("R"), 3, 1);
        keyboard.attach (new Key ("A"), 0, 2);
        keyboard.attach (new Key ("S"), 1, 2);
        keyboard.attach (new Key ("D"), 2, 2);
        keyboard.attach (new Key ("F"), 3, 2);
        keyboard.attach (new Key ("Z"), 0, 3);
        keyboard.attach (new Key ("X"), 1, 3);
        keyboard.attach (new Key ("C"), 2, 3);
        keyboard.attach (new Key ("V"), 3, 3);

        var grid = new Gtk.Grid () {
            margin_start = 30,
            margin_end = 30,
            margin_bottom = 10,
            column_spacing = 10,
            row_spacing = 10
        };

        grid.attach (new Granite.HeaderLabel ("Keyboard") {
            halign = Gtk.Align.CENTER
        }, 0, 0);
        grid.attach (new Granite.HeaderLabel ("COSMAC VIP Keypad") {
            halign = Gtk.Align.CENTER
        }, 2, 0);
        grid.attach (keyboard, 0, 1);
        grid.attach (new Gtk.Image () {
            gicon = new ThemedIcon ("go-next-symbolic"),
            pixel_size = 24
        }, 1, 1);
        grid.attach (keypad, 2, 1);

        get_content_area ().add (grid);

        var close_button = new Gtk.Button.with_label (_("Close"));
        close_button.clicked.connect (() => {
            close ();
        });
        add_action_widget (close_button, 0);
    }

}
